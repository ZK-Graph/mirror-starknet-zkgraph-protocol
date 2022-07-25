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
# Storage
#

@storage_var
func profile_id_by_hh_storage(handle : Uint256) -> (profile_id_by_hh_storage : Uint256):
end


@storage_var
func profile_by_id(profile_id : Uint256) -> (profileStruct : DataTypes.ProfileStruct):
end

#
# Events
#

@event
func event_profile_created(
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
func event_follow_module_set(
    profile_id : Uint256, # should be indexed
    follow_module : felt,
    follow_module_return_data : felt,
    timestamp : felt):
end

@event
func event_post_created(
        profile_id : Uint256, # should be indexed
        pub_id : Uint256, # should be indexed
        content_uri : felt, # string
        collect_module : felt, # address
        collect_module_return_data : felt, # bytes
        reference_module : felt, # address
        reference_module_return_data : felt, # bytes
        timestamp : felt):
end

#
# Internal
#
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


func uint256_to_address_felt(x : Uint256) -> (address : felt):
    return (x.low + x.high * 2 ** 128)
end

func felt_to_uint256{range_check_ptr}(x) -> (x_ : Uint256):
    let split = split_felt(x)
    return (Uint256(low=split.low, high=split.high))
end


func create_profile{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*
    }(vars : DataTypes.CreateProfileData, profile_id : Uint256, _profile_id_by_handle_hash : felt, _profile_by_id : DataTypes.ProfileStruct, _follow_module_whitelisted : felt
    ) -> ():
    alloc_locals
    let (handle_hash) = get_keccak_hash(vars.handle)
    with_attr error_message("Profile ID by Handle Hash != 0"):
	    let (profile_id_by_handle_hash : Uint256) = profile_id_by_hh_storage.read(handle_hash)
	    let (profile_id_felt : felt) = uint256_to_address_felt(profile_id_by_handle_hash)
	    assert_not_zero(profile_id_felt)
    end

    profile_id_by_hh_storage.write(handle_hash, profile_id)

    let (pub_count : Uint256) = felt_to_uint256(0)
    let (local struct_array : DataTypes.ProfileStruct*) = alloc()

    if vars.follow_module != 0:
        assert struct_array[0] = DataTypes.ProfileStruct(pub_count=pub_count, follow_module=vars.follow_module, follow_nft=0, handle=vars.handle, image_uri=vars.image_uri, follow_nft_uri=vars.follow_nft_uri)
        let (follow_module_return_data) = _init_follow_module(profile_id, vars.follow_module, vars.follow_module_init_data, _follow_module_whitelisted)
        profile_by_id.write(profile_id, struct_array[0])
        _emit_profile_created(profile_id, vars, follow_module_return_data)
        return ()
    else:
        assert struct_array[0] = DataTypes.ProfileStruct(pub_count=pub_count, follow_module=0, follow_nft=0, handle=vars.handle, image_uri=vars.image_uri, follow_nft_uri=vars.follow_nft_uri)
        profile_by_id.write(profile_id, struct_array[0])
        return ()
    end
end


func set_follow_module{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profile_id : Uint256, follow_module : felt, follow_module_init_data : felt, _profile : DataTypes.ProfileStruct, _follow_module_whitelisted : felt) -> ():
    let (follow_module_return_data) = _init_follow_module(profile_id, follow_module, follow_module_init_data, _follow_module_whitelisted)

    let (block_timestamp) = get_block_timestamp()
    event_follow_module_set.emit(profile_id, follow_module, follow_module_return_data, block_timestamp)
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
    event_profile_created.emit(profile_id, sender_address, vars.to, vars.handle, vars.image_uri, vars.follow_module, _follow_module_return_data, vars.follow_nft_uri, block_timestamp)
    return ()
end
