%lang starknet

from starkware.cairo.common.uint256 import Uint256


@contract_interface
namespace IFollowNFT:

    # * @notice Initializes the follow NFT, setting the hub as the privileged minter and storing the associated profile ID.
    # *
    # * @param profileId The token ID of the profile in the hub associated with this followNFT, used for transfer hooks.
    func initialize(profileId : Uint256):
    end


    # * @notice Mints a follow NFT to the specified address. This can only be called by the hub, and is called
    # * upon follow.
    # *
    # * @param to The address to mint the NFT to.
    # *
    # * @return uint256 An interger representing the minted token ID.
    func mint(to : felt) -> (tokenId : Uint256):
    end


    # * @notice Returns the governance power for a given user at a specified block number.
    # *
    # * @param user The user to query governance power for.
    # * @param blockNumber The block number to query the user's governance power at.
    # *
    # * @return uint256 The power of the given user at the given block number.
    func getPowerByBlockNumber(user : felt, blockNumber : Uint256) -> (power : Uint256):
    end


    # * @notice Returns the total delegated supply at a specified block number. This is the sum of all
    # * current available voting power at a given block.
    # *
    # * @param blockNumber The block number to query the delegated supply at.
    # *
    # * @return uint256 The delegated supply at the given block number.
    func getDelegatedSupplyByBlockNumber(blockNumber : Uint256) -> (delegatedSupply : Uint256):
    end
end
