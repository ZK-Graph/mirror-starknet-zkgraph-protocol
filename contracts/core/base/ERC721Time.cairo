// SPDX-License-Identifier: MIT

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.access.ownable.library import Ownable

from libraries.ERC721_Metadata import (
    ERC721_Metadata_tokenURI,
    ERC721_Metadata_setBaseTokenURI,
)

namespace ERC721Time {
    func initialize{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*, 
            range_check_ptr
        }(
        name : felt,
        symbol : felt,
        owner : felt,
        base_token_uri_len : felt,
        base_token_uri : felt*,
        //token_uri_suffix : felt,
    ) {
        ERC721.initializer(name, symbol);
        ERC721Enumerable.initializer();
        Ownable.initializer(owner);
        ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri); //token_uri_suffix
        return ();
    }

    //
    // Getters
    //

    @view
    func getOwner{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        owner : felt
    ) {
        let owner = Ownable.owner();
        return (owner=owner);
    }

    @view
    func supportsInterface{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        interface_id : felt
    ) -> (success : felt) {
        let success = ERC165.supports_interface(interface_id);
        return (success=success);
    }

    @view
    func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt) {
        let name = ERC721.name();
        return (name=name);
    }

    @view
    func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (symbol : felt) {
        let symbol = ERC721.symbol();
        return (symbol=symbol);
    }

    @view
    func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(owner : felt) -> (
        balance : Uint256
    ) {
        let balance : Uint256 = ERC721.balance_of(owner);
        return (balance=balance);
    }

    @view
    func ownerOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256
    ) -> (owner : felt) {
        let owner : felt = ERC721.owner_of(token_id);
        return (owner=owner);
    }

    @view
    func getApproved{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256
    ) -> (approved : felt) {
        let (approved : felt) = ERC721.get_approved(token_id);
        return (approved=approved);
    }

    @view
    func isApprovedForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt, operator : felt
    ) -> (is_approved : felt) {
        let (is_approved : felt) = ERC721.is_approved_for_all(owner, operator);
        return (is_approved=is_approved);
    }

    @view
    func tokenURI{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256
    ) -> (token_uri_len : felt, token_uri : felt*) {
        let (token_uri_len, token_uri) = ERC721_Metadata_tokenURI(token_id);
        return (token_uri_len=token_uri_len, token_uri=token_uri);
    }

    //
    // Externals
    //

    func approve{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        to : felt, token_id : Uint256
    ) {
        ERC721.approve(to, token_id);
        return ();
    }

    func setApprovalForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        operator : felt, approved : felt
    ) {
        ERC721.set_approval_for_all(operator, approved);
        return ();
    }

    func transferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        _from : felt, to : felt, token_id : Uint256
    ) {
        ERC721Enumerable.transfer_from(_from, to, token_id);
        return ();
    }

    func safeTransferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        _from : felt, to : felt, token_id : Uint256, data_len : felt, data : felt*
    ) {
        ERC721Enumerable.safe_transfer_from(_from, to, token_id, data_len, data);
        return ();
    }

    func setTokenURI{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        base_token_uri_len : felt, base_token_uri : felt*, token_uri_suffix : felt
    ) {
        Ownable.assert_only_owner();
        ERC721_Metadata_setBaseTokenURI(base_token_uri_len, base_token_uri, token_uri_suffix);
        return ();
    }

    func mint{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        to : felt, token_id : Uint256
    ) {
        // Ownable.assert_only_owner()
        ERC721Enumerable._mint(to, token_id);
        return ();
    }

    func burn{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(token_id : Uint256) {
        Ownable.assert_only_owner();
        ERC721Enumerable._burn(token_id);
        return ();
    }

    func transferOwnership{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        new_owner : felt
    ) -> (new_owner : felt) {
        // Ownership check is handled by this function
        Ownable.transfer_ownership(new_owner);
        return (new_owner=new_owner);
    }
}