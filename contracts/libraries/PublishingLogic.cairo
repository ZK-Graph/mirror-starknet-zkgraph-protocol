%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_keccak.keccak import keccak_uint256s, keccak_felts, keccak
from starkware.cairo.common.keccak import unsafe_keccak
from starkware.cairo.common.math import assert_not_zero, assert_nn
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address, get_block_timestamp

from DataTypes import CreateProfileData, ProfileStruct
from interfaces.IFollowModule import IFollowModule



@storage_var
func profile_id_by_hh_storage(handle : felt) -> (profile_id_by_hh_storage : felt):
end


@storage_var
func profileById(profileId : felt) -> (profileStruct : ProfileStruct):
end

@event
func emitProfileCreated(profileId : Uint256, sender : felt, to : felt, handle : felt, imageURI : felt, followModule : felt, followModuleReturnData : felt, followNFTURI : felt, time : Uint256):
end


func createProfile{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(vars : CreateProfileData, profileId : Uint256, _profileIdByHandleHash : felt, _profileById : ProfileStruct, _followModuleWhitelisted : felt
    ) -> ():
    let handleHash = keccak(&vars.handle, 32)

    with_attr error_message("Profile ID by Handle Hash != 0"):
	let (profileIdByHandleHash) = profile_id_by_hh_storage.read(handleHash)
	assert_not_zero(profileIdByHandleHash)
    end

    profile_id_by_hh_storage.write(handleHash, profileId)
    struct profileTemp:
        member pubCount : Uint256
        member followModule : felt
        member followNFT : felt
        member handle : felt
        member imageURI : felt
        member followNFTURI : felt
    end

#    let (profileTemp : ProfileStruct) 
    profileTemp.handle = vars.handle
    profileTemp.imageURI = vars.imageURI
    profileTemp.followNFTURI = vars.followNFTURI

#    if vars.followModule != "0x0"
    profileTemp.followModule = vars.followModule
    let (followModuleReturnData) = _initFollowModule(profileId, vars.followModule, vars.followModuleInitData, _followModuleWhitelisted)
#   end

    profileById.write(profileId, profileTemp)
    _emitProfileCreated(profileId, vars, followModuleReturnData)
    return ()
end


func _initFollowModule{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profileId : Uint256, _followModule : felt, _followModuleInitData : felt, _followModuleWhitelisted : felt
    ) -> (mem : felt):
    with_attr error_message("Follow module not whitelisted"):
        assert_nn(_followModuleWhitelisted)
    end
    return (IFollowModule.initializeFollowModule(profileId, _followModuleInitData))
end


func _emitProfileCreated{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(profileId : Uint256, vars : CreateProfileData, _followModuleReturnData
    ) -> ():
    let (sender_address) = get_caller_address()
    let (block_timestamp) = get_block_timestamp()
    emitProfileCreated.emit(profileId, sender_address, vars.to, vars.handle, vars.imageURI, vars.followModule, _followModuleReturnData, vars.followNFTURI, block_timestamp)
    return ()
end