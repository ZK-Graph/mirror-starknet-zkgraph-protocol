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
from libraries.PublishingLogic import PublishingLogic
from libraries.InteractionLogic import InteractionLogic
from core.base.ERC721Time import ERC721Time


//
// Storage
//

@storage_var
func profile_counter() -> (number: Uint256) {
}

@storage_var
func follow_nft() -> (address: felt) {
}
//
// Events
//

@event
func BaseInitialized(name : felt, symbol : felt, timestamp : felt) {
}


func felt_to_uint256{range_check_ptr}(x) -> Uint256 {
    let split = split_felt(x);
    return (Uint256(low=split.low, high=split.high));
}


@constructor
func constructor{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(name : felt, symbol : felt, owner : felt, _follow_nft: felt, token_uri_len: felt, token_uri: felt*) {
    ERC721Time.initialize(name, symbol, owner, token_uri_len, token_uri);
    let profile_cnt : Uint256 = felt_to_uint256(0);
    profile_counter.write(profile_cnt);
    follow_nft.write(_follow_nft);
    return();
}

    
func get_profile_counter{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> Uint256 {
    let number : Uint256 = profile_counter.read();
    return (number);
}

////// Profile Owner Functions //////
@external
func create_profile{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
    bitwise_ptr : BitwiseBuiltin*
}(create_profile_data : DataTypes.CreateProfileData) -> (profile_id : Uint256) {
    alloc_locals;
    let _profile_counter : Uint256 = profile_counter.read();
    let profile_id : Uint256 = SafeUint256.add(_profile_counter, Uint256(1, 0));
    let caller: felt = get_caller_address();
    ERC721Time.mint(caller, profile_id);
    PublishingLogic.create_profile(create_profile_data, profile_id, 0);
    profile_counter.write(profile_id);
    return (profile_id=profile_id);
}

@external
func transferFrom{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(_from: felt, to: felt, token_id: Uint256) {
    let ownerOf: felt = ERC721.owner_of(token_id);
    with_attr error_message("From != owner of token") {
        assert ownerOf = _from;
    }
    ERC721Time.transferFrom(_from, to, token_id);
    return();
}
//func set_follow_module

@external
func approve{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(to: felt, token_id: Uint256) {
    ERC721Time.approve(to, token_id);
    return();
}
	
@external
func setApprovalForAll{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(operator: felt, approved: felt) {
    ERC721Time.setApprovalForAll(operator, approved);
    return();
}

@external
func follow{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*
    }(profile_id: Uint256) {
    let sender: felt = get_caller_address();
    let _follow_nft: felt = follow_nft.read();
    InteractionLogic.follow(sender, profile_id, 0, _follow_nft);
    return ();
}
