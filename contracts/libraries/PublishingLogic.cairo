%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_not
from starkware.cairo.common.cairo_keccak.keccak import keccak_uint256s, keccak_felts, finalize_keccak
from starkware.cairo.common.math import assert_not_zero, assert_nn, split_felt
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address, get_block_timestamp

from libraries.DataTypes import DataTypes
from interfaces.IFollowModule import IFollowModule

#
# Title: PublishingLogic
# Author: zkGraph 
#
# This is the library that contains the logic for profile creation & publication.
#

# 
# Storage
#

@storage_var
func profile_by_id(profile_id : Uint256) -> (profileStruct : DataTypes.ProfileStruct):
end

@storage_var
func profile_id_by_hh_storage(handle : felt) -> (profile_id : Uint256):
end

@storage_var
func publication_id_by_profile(profile_id : Uint256) -> (retval : DataTypes.PublicationStruct):
end

#
# Events
#

@event
func ProfileCreated(
    profile_id : Uint256, 
    sender : felt, 
    to : felt, 
    handle : felt, 
    image_uri : felt, 
    follow_module : felt, 
    follow_module_return_data : felt, 
    follow_nft_uri : felt, 
    timestamp : felt):
end

@event
func FollowModuleSet(
    profile_id : Uint256, # should be indexed
    follow_module : felt,
    follow_module_return_data : felt,
    timestamp : felt):
end

@event
func PostCreated(
    profile_id : Uint256, # should be indexed
    publication_id : Uint256, # should be indexed
    content_uri : felt, # string
    timestamp : felt):
end

#
# Getters
#

# Function. Getter. Returns ProfileStruct by profile_id
# Params:
# profile_id - Uint256 profile ID

@view
func get_profile_by_id{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
    }(profile_id : Uint256) -> (profile : DataTypes.ProfileStruct):

    let (profile : DataTypes.ProfileStruct) = profile_by_id.read(profile_id)

    return (profile)
end

# Function. Getter. Custom function to return one of free elements of DataTypes.ProfileStruct 
# Params:
# profile_id - Uint256 profile ID
# element - element of DataTypes.ProfileStruct
#   element = 0 -> handle
#   element = 1 -> follow_module
#   element = 2 -> follow_nft

@view
func get_profile_element_by_id{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
    }(profile_id : Uint256, element : felt) -> (profile : felt):
    let (profile : DataTypes.ProfileStruct) = profile_by_id.read(profile_id)

    if element == 0:
        return (profile.handle)
    end

    if element == 1:
	    return (profile.follow_module)
    end

    if element == 2:
	    return (profile.follow_nft)
    end

    return (0)
end

# Function. Getter. Returns profile_id by handle hash
# Params:
# handle_hash - keccak hash function of Profile's handle

@view
func get_profile_by_hh{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
    }(handle_hash : felt) -> (profile_id : Uint256):

    let (profile_id : Uint256) = profile_id_by_hh_storage.read(handle_hash)

    return (profile_id)
end

#
# Internal
#

# Function. Internal. Keccak hash function calculation
# Params:
# value_to_hash - felt value we would like to calculate hash from. For example: profile's handle

func get_keccak_hash{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
    bitwise_ptr : BitwiseBuiltin*
    }(value_to_hash : felt) -> (hashed_value : Uint256):

    alloc_locals

    let (local keccak_ptr_start) = alloc()
    let keccak_ptr = keccak_ptr_start
    let (local arr : felt*) = alloc()
    assert arr[0] = value_to_hash


    let (hashed_value) = keccak_felts{keccak_ptr=keccak_ptr}(1, arr)
    finalize_keccak(keccak_ptr_start=keccak_ptr_start, keccak_ptr_end=keccak_ptr)

    return (hashed_value)
end

# Two Uint256 / felt functions

func uint256_to_address_felt(x : Uint256) -> (address : felt):
    return (x.low + x.high * 2 ** 128)
end

func felt_to_uint256{range_check_ptr}(x) -> (x_ : Uint256):
    let split = split_felt(x)
    return (Uint256(low=split.low, high=split.high))
end

# Function. Internal. Executes the logic to create a profile with the given parameters to the given address.
# Params:
# vars - The CreateProfileData struct containing the following parameters
#    to - The address receiving the profile
#    handle - The handle to set for the profile, must be unique and non-empty
#    imageURI - The URI to set for the profile image
#    followModule - The follow module to use, can be the zero address
#    followModuleInitData - The follow module initialization data, if any
#    followNFTURI - The URI to set for the follow NFT
# profile_id - Uint256 profile ID
# _followModuleWhitelisted - The storage reference to the mapping of whitelist status by follow module address


func create_profile{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*
    }(vars : DataTypes.CreateProfileData, profile_id : Uint256, _follow_module_whitelisted : felt
    ) -> ():
    alloc_locals

    # we validate that profile_id_by_hh_storage storage has appropriate  
    # handle -> profile_id pair
    # actually we just check whether or not such Handle is exists 

    let (handle_hash) = get_keccak_hash(vars.handle)
    let (handle_hash_felt) = uint256_to_address_felt(handle_hash)
    with_attr error_message("Profile ID by Handle Hash != 0. Such handle is exists. This handle is taken"):
	    let (profile_id_by_handle_hash : Uint256) = profile_id_by_hh_storage.read(handle_hash_felt)
	    let (profile_id_felt : felt) = uint256_to_address_felt(profile_id_by_handle_hash)
	    assert_not_zero(profile_id_felt)
    end

    # add new record to profile_id_by_hh_storage storage
    
    profile_id_by_hh_storage.write(handle_hash_felt, profile_id)


    let publications_count : Uint256 = Uint256(0, 0)
    let (local struct_array : DataTypes.ProfileStruct*) = alloc()

    # refactoring is required

    if vars.follow_module != 0:
        assert struct_array[0] = DataTypes.ProfileStruct(pub_count=publications_count, follow_module=vars.follow_module, follow_nft=0, handle=vars.handle, image_uri=vars.image_uri, follow_nft_uri=vars.follow_nft_uri)
        let (follow_module_return_data) = _init_follow_module(profile_id, vars.follow_module, vars.follow_module_init_data, _follow_module_whitelisted)
        profile_by_id.write(profile_id, struct_array[0])
        _emit_profile_created(profile_id, vars, follow_module_return_data)
        return ()

    else:
        assert struct_array[0] = DataTypes.ProfileStruct(pub_count=publications_count, follow_module=0, follow_nft=0, handle=vars.handle, image_uri=vars.image_uri, follow_nft_uri=vars.follow_nft_uri)
        profile_by_id.write(profile_id, struct_array[0])
        _emit_profile_created(profile_id, vars, 0)
        return ()

    end
end

# Function. Internal. Creates a post publication mapped to the given profile.
# Params:
# profile_id - The profile ID to associate this publication to.
# content_uri - The URI to set for this publication.
# publication_id - The publication ID to associate with this publication.
# _publication_id_by_profile - The storage reference to the mapping of publications by publication ID by profile ID.

func create_post{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*
    }(profile_id : Uint256, content_uri : felt, publication_id : Uint256, _publication_id_by_profile : felt
    ) -> ():

    alloc_locals
    let (local struct_array : DataTypes.PublicationStruct*) = alloc()

    assert struct_array[0] = DataTypes.PublicationStruct(profile_id_pointed=profile_id, pub_id_pointed=publication_id, content_uri=content_uri)
    publication_id_by_profile.write(profile_id, struct_array[0])
    let (timestamp : felt) = get_block_timestamp()
    PostCreated.emit(profile_id, publication_id, content_uri, timestamp)
    return ()
end

# Function. Internal. Sets the follow module for a given profile.
# Params:
# 

func set_follow_module{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profile_id : Uint256, follow_module : felt, follow_module_init_data : felt, _profile : DataTypes.ProfileStruct, _follow_module_whitelisted : felt) -> ():
    let (follow_module_return_data) = _init_follow_module(profile_id, follow_module, follow_module_init_data, _follow_module_whitelisted)

    let (block_timestamp) = get_block_timestamp()
    FollowModuleSet.emit(profile_id, follow_module, follow_module_return_data, block_timestamp)
    return ()
end


func _init_follow_module{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profile_id : Uint256, _follow_module : felt, _follow_module_init_data : felt, _follow_module_whitelisted : felt
    ) -> (mem : felt):
    with_attr error_message("Follow module not whitelisted"):
        assert_nn(_follow_module_whitelisted)
    end
    let (sender) = get_caller_address()
    let ( retval : felt ) = IFollowModule.initialize_follow_module(sender, profile_id, _follow_module_init_data)
    return (retval)
end


func _emit_profile_created{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profile_id : Uint256, vars : DataTypes.CreateProfileData, _follow_module_return_data
    ) -> ():
    let (sender_address) = get_caller_address()
    let (block_timestamp) = get_block_timestamp()
    ProfileCreated.emit(profile_id, sender_address, vars.to, vars.handle, vars.image_uri, vars.follow_module, _follow_module_return_data, vars.follow_nft_uri, block_timestamp)
    return ()
end
