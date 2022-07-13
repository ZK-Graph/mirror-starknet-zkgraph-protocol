%lang starknet

from starkware.cairo.common.uint256 import Uint256


@contract_interface
namespace IFollowModule:
    func initializeFollowModule(profileId : Uint256, data : felt) -> (selector : felt):
    end
end
