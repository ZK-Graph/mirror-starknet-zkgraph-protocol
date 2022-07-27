%lang starknet

from starkware.cairo.common.uint256 import Uint256


@contract_interface
namespace IFollowModule:

    # * @notice Initializes a follow module for a given Lens profile. This can only be called by the hub contract.
    # *
    # * @param profileId The token ID of the profile to initialize this follow module for.
    # * @param data Arbitrary data passed by the profile creator.
    # *
    # * @return bytes The encoded data to emit in the hub.
    func initialize_follow_module(profile_id : Uint256, data : felt) -> (retval : felt):
    end

    # * @notice Processes a given follow, this can only be called from the LensHub contract.
    # *
    # * @param follower The follower address.
    # * @param profileId The token ID of the profile being followed.
    # * @param data Arbitrary data passed by the follower.
    func process_follow(follower : felt, profile_id : Uint256, data : felt) -> (retval : felt):
    end
end
