%lang starknet

from starkware.cairo.common.uint256 import Uint256


@contract_interface
namespace ICollectModule:
    # * @notice Initializes data for a given publication being published. This can only be called by the hub.
    # *
    # * @param profileId The token ID of the profile publishing the publication.
    # * @param pubId The associated publication's LensHub publication ID.
    # * @param data Arbitrary data __passed from the user!__ to be decoded.
    # *
    # * @return bytes An abi encoded byte array encapsulating the execution's state changes. This will be emitted by the
    # * hub alongside the collect module's address and should be consumed by front ends.
    func initializePublicationCollectModule(
        profileId : Uint256,
        pubId : Uint256,
        data : felt) -> (retval : felt):
    end

    
    # * @notice Processes a collect action for a given publication, this can only be called by the hub.
    # *
    # * @param referrerProfileId The LensHub profile token ID of the referrer's profile (only different in case of mirrors).
    # * @param collector The collector address.
    # * @param profileId The token ID of the profile associated with the publication being collected.
    # * @param pubId The LensHub publication ID associated with the publication being collected.
    # * @param data Arbitrary data __passed from the collector!__ to be decoded.
    func processCollect(
        referrerProfileId : Uint256,
        collector : felt,
        profileId : Uint256,
        pubId : Uint256,
        data : felt):
    end
end
