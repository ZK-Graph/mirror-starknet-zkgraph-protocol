%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_not
from starkware.cairo.common.cairo_keccak.keccak import keccak_uint256s, keccak_felts, finalize_keccak
from starkware.cairo.common.math import assert_not_zero, assert_nn, split_felt
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address, get_block_timestamp

from libraries.DataTypes import CreateProfileData, ProfileStruct
from interfaces.IFollowModule import IFollowModule



@storage_var
func profile_id_by_hh_storage(handle : Uint256) -> (profile_id_by_hh_storage : Uint256):
end


@storage_var
func profileById(profileId : Uint256) -> (profileStruct : ProfileStruct):
end

@event
func emitProfileCreated(
    profileId : Uint256, 
    sender : felt, 
    to : felt, 
    handle : felt, 
    imageURI : felt, 
    followModule : felt, 
    followModuleReturnData : felt, 
    followNFTURI : felt, 
    time : felt):
end

@event
func eventFollowModuleSet(
    profileId : Uint256, # should be indexed
    followModule : felt,
    followModuleReturnData : felt,
    timestamp : felt):
end

@event
func eventPostCreated(
        profileId : Uint256, # should be indexed
        pubId : Uint256, # should be indexed
        contentURI : felt, # string
        collectModule : felt, # address
        collectModuleReturnData : felt, # bytes
        referenceModule : felt, # address
        referenceModuleReturnData : felt, # bytes
        timestamp : felt):
end


func uint256_to_address_felt(x : Uint256) -> (address : felt):
    return (x.low + x.high * 2 ** 128)
end

func felt_to_uint256{range_check_ptr}(x) -> (x_ : Uint256):
    let split = split_felt(x)
    return (Uint256(low=split.low, high=split.high))
end


func createProfile{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(vars : CreateProfileData, profileId : Uint256, _profileIdByHandleHash : felt, _profileById : ProfileStruct, _followModuleWhitelisted : felt, handleHash : Uint256
    ) -> ():
    alloc_locals
    with_attr error_message("Profile ID by Handle Hash != 0"):
	let (profileIdByHandleHash : Uint256) = profile_id_by_hh_storage.read(handleHash)
	let (profileIdFelt : felt) = uint256_to_address_felt(profileIdByHandleHash)
	assert_not_zero(profileIdFelt)
	
    end

    profile_id_by_hh_storage.write(handleHash, profileId)

    let (pubCount : Uint256) = felt_to_uint256(0)
    let (local struct_array : ProfileStruct*) = alloc()
    assert struct_array[0] = ProfileStruct(pubCount=pubCount, followModule=vars.followModule, followNFT=0, handle=vars.handle, imageURI=vars.imageURI, followNFTURI=vars.followNFTURI)


    let (followModuleReturnData) = _initFollowModule(profileId, vars.followModule, vars.followModuleInitData, _followModuleWhitelisted)


    profileById.write(profileId, struct_array[0])
    _emitProfileCreated(profileId, vars, followModuleReturnData)
    return ()
end


func setFollowModule{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profileId : Uint256, followModule : felt, followModuleInitData : felt, _profile : ProfileStruct, _followModuleWhitelisted : felt) -> ():
    let (followModuleReturnData) = _initFollowModule(profileId, followModule, followModuleInitData, _followModuleWhitelisted)

    let (block_timestamp) = get_block_timestamp()
    eventFollowModuleSet.emit(profileId, followModule, followModuleReturnData, block_timestamp)
    return ()
end


func _initFollowModule{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profileId : Uint256, _followModule : felt, _followModuleInitData : felt, _followModuleWhitelisted : felt
    ) -> (mem : felt):
    with_attr error_message("Follow module not whitelisted"):
        assert_nn(_followModuleWhitelisted)
    end
    let (sender) = get_caller_address()
    let ( retval : felt ) = IFollowModule.initializeFollowModule(sender, profileId, _followModuleInitData)
    return (retval)
end


func _emitProfileCreated{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profileId : Uint256, vars : CreateProfileData, _followModuleReturnData
    ) -> ():
    let (sender_address) = get_caller_address()
    let (block_timestamp) = get_block_timestamp()
    emitProfileCreated.emit(profileId, sender_address, vars.to, vars.handle, vars.imageURI, vars.followModule, _followModuleReturnData, vars.followNFTURI, block_timestamp)
    return ()
end
