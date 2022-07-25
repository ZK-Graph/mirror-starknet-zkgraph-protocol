%lang starknet

from starkware.cairo.common.uint256 import Uint256
from libraries.DataTypes import DataTypes


@contract_interface
namespace IERC721Time:
    # * @notice Returns the mint timestamp associated with a given NFT, stored only once upon initial mint.
    # *
    # * @param tokenId The token ID of the NFT to query the mint timestamp for.
    # *
    # * @return uint256 mint timestamp
    func mint_timestamp_of(token_id : Uint256) -> (timestamp : Uint256):
    end

    # * @notice Returns the token data associated with a given NFT. This allows fetching the token owner and
    # * mint timestamp in a single call.
    # *
    # * @param tokenId The token ID of the NFT to query the token data for.
    # *
    # * @return TokenData token data struct containing both the owner address and the mint timestamp.
    func token_data_of(token_id : Uint256) -> (token_data : DataTypes.TokenData):
    end

    # * @notice Returns whether a token with the given token ID exists.
    # *
    # * @param tokenId The token ID of the NFT to check existence for.
    # *
    # * @return bool True if the token exists.
    func exists(token_id) -> (token_exists : felt):
    end
end