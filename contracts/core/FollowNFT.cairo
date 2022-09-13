%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_not, uint256_check
from starkware.cairo.common.cairo_keccak.keccak import keccak_uint256s, keccak_felts, finalize_keccak
from starkware.cairo.common.math import assert_not_zero, assert_nn, split_felt, assert_not_equal, assert_le
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address, get_block_timestamp, get_tx_info
from starkware.cairo.common.cairo_secp.signature import recover_public_key, public_key_point_to_eth_address
from starkware.cairo.common.cairo_secp.ec import EcPoint

from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc721.library import ERC721


from libraries.DataTypes import DataTypes
from libraries.constants import EIP712_REVISION, PERMIT, PERMIT_FOR_ALL, BURN_WITH_SIG, EIP712_DOMAIN
from libraries.PublishingLogic import PublishingLogic
from core.base.ERC721Time import ERC721Time


#
# Storage
#

@storage_var
func follow_counter() -> (number: Uint256):
end
#
# Events
#

@event
func BaseInitialized(name : felt, symbol : felt, timestamp : felt):
end


func felt_to_uint256{range_check_ptr}(x) -> (x_ : Uint256):
    let split = split_felt(x)
    return (Uint256(low=split.low, high=split.high))
end


namespace FollowNFT:
    
    @constructor
    func constructor{
	syscall_ptr: felt*,
	pedersen_ptr: HashBuiltin*,
	range_check_ptr
    }(name : felt, symbol : felt, owner : felt, token_uri_len: felt, token_uri: felt*):
	ERC721Time.initialize(name, symbol, owner, token_uri_len, token_uri)
        let (follow_cnt : Uint256) = felt_to_uint256(0)
        follow_counter.write(follow_cnt)
        return()
    end

    func get_follow_counter{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }() -> (number : Uint256):
        let (number) = follow_counter.read()
        return (number)
    end

    ### Functions ###
    @external
    func mint{
	syscall_ptr: felt*,
	pedersen_ptr: HashBuiltin*,
	range_check_ptr
    }(to: felt) -> (profile_id : Uint256): 
        alloc_locals
        let (_follow_counter : Uint256) = follow_counter.read()
	let (follow_id : Uint256) = SafeUint256.add(_follow_counter, Uint256(1, 0))
	ERC721Time.mint(to, follow_id)
        follow_counter.write(follow_id)
	return (follow_id)
    end  

    @external
    func transferFrom{
            syscall_ptr: felt*,
            pedersen_ptr: HashBuiltin*,
            range_check_ptr,
        }(_from: felt, to: felt, token_id: Uint256):
        let (ownerOf: felt) = ERC721.owner_of(token_id)
        with_attr error_message("From != owner of token"):
            assert ownerOf = _from
        end
        ERC721Time.transferFrom(_from, to, token_id)
        return()
    end

    @external
    func approve{
            syscall_ptr: felt*,
            pedersen_ptr: HashBuiltin*,
            range_check_ptr,
        }(to: felt, token_id: Uint256):
        ERC721Time.approve(to, token_id)
        return()
    end
	
    @external
    func setApprovalForAll{
            syscall_ptr: felt*,
            pedersen_ptr: HashBuiltin*,
            range_check_ptr,
        }(operator: felt, approved: felt):
        ERC721Time.setApprovalForAll(operator, approved)
        return()
    end
end
