%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_not
from starkware.cairo.common.cairo_keccak.keccak import keccak_uint256s, keccak_felts, finalize_keccak
from starkware.cairo.common.math import assert_not_zero, assert_nn, split_felt
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address, get_block_timestamp

from DataTypes import CreateProfileData, ProfileStruct
from interfaces.IFollowModule import IFollowModule



@storage_var
func profile_id_by_hh_storage(handle : Uint256) -> (profile_id_by_hh_storage : Uint256):
end


@storage_var
func profileById(profileId : Uint256) -> (profileStruct : ProfileStruct):
end

@event
func emitProfileCreated(profileId : Uint256, sender : felt, to : felt, handle : felt, imageURI : felt, followModule : felt, followModuleReturnData : felt, followNFTURI : felt, time : felt):
end

#@view
#func view_get_keccak_hash{
#    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
#}(value_to_hash : felt) -> (hashed_value : Uint256):
#    alloc_locals
#    let (local keccak_ptr_start) = alloc()
#    let keccak_ptr = keccak_ptr_start
#    let (local arr : felt*) = alloc()
#    assert arr[0] = value_to_hash
#    let (hashed_value) = keccak_felts{keccak_ptr=keccak_ptr}(1, arr)
#    finalize_keccak(keccak_ptr_start=keccak_ptr_start, keccak_ptr_end=keccak_ptr)
#    return (hashed_value)
#end


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
    ### remove handleHash from args ###
    #let handleHash = keccak(&vars.handle, 32)
    #let (handleHash) = view_get_keccak_hash(vars.handle)
    alloc_locals
    with_attr error_message("Profile ID by Handle Hash != 0"):
	let (profileIdByHandleHash : Uint256) = profile_id_by_hh_storage.read(handleHash)
	let (profileIdFelt : felt) = uint256_to_address_felt(profileIdByHandleHash)
	assert_not_zero(profileIdFelt)
	
    end

    profile_id_by_hh_storage.write(handleHash, profileId)
#    struct profileTemp:
#        member pubCount : Uint256
#        member followModule : felt
#        member followNFT : felt
#        member handle : felt
#        member imageURI : felt
#        member followNFTURI : felt
#    end
    let (pubCount : Uint256) = felt_to_uint256(0)
    let (local struct_array : ProfileStruct*) = alloc()
    assert struct_array[0] = ProfileStruct(pubCount=pubCount, followModule=vars.followModule, followNFT=0, handle=vars.handle, imageURI=vars.imageURI, followNFTURI=vars.followNFTURI)
#    let (profileTemp : ProfileStruct) = struct_array[0]
#    let (profileTemp : ProfileStruct) = alloc()
#    profileTemp.handle = vars.handle
#    profileTemp.imageURI = vars.imageURI
#    profileTemp.followNFTURI = vars.followNFTURI

#    if vars.followModule != "0x0"
#    profileTemp.followModule = vars.followModule

    let (followModuleReturnData) = _initFollowModule(profileId, vars.followModule, vars.followModuleInitData, _followModuleWhitelisted)
#   end

    profileById.write(profileId, struct_array[0])
    _emitProfileCreated(profileId, vars, followModuleReturnData)
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
