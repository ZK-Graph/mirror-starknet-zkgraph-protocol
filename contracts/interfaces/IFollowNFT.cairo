%lang starknet

from starkware.cairo.common.uint256 import Uint256


@contract_interface
namespace IFollowNFT{

    // * @notice Initializes the follow NFT, setting the hub as the privileged minter and storing the associated profile ID.
    // *
    // * @param profile_id The token ID of the profile in the hub associated with this followNFT, used for transfer hooks.

    func initialize(profile_id : Uint256) {
    }
    
    // * @notice Mints a follow NFT to the specified address. This can only be called by the hub, and is called
    // * upon follow.
    // *
    // * @param to The address to mint the NFT to.
    // *
    // * @return uint256 An interger representing the minted token ID.

    func mint(to : felt) -> (token_id : Uint256){
    }
}
