%lang starknet

from starkware.cairo.common.uint256 import Uint256


@contract_interface
namespace IFollowModule:
    func initialize_follow_module(profile_id : Uint256, data : felt) -> (selector : felt):
    end
end
