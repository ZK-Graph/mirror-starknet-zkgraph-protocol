%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin


namespace DataTypes:
	struct EIP712Signature:
    	member v : felt
	    member r : Uint256
	    member s : Uint256
	    member deadline: Uint256
	end

	struct ProfileStruct:
	    member pub_count : Uint256
	    member follow_module : felt
	    member follow_nft : felt
	    member handle : felt
	    member image_uri : felt
	    member follow_nft_uri : felt
	end

	struct PublicationStruct:
	    member profile_id_pointed : Uint256
	    member pub_id_pointed : Uint256
	    member content_uri : felt
#	    member reference_module : felt
#	    member collect_module : felt
#	    member collect_nft : felt
	end

	struct CreateProfileData:
    	member to : felt
	    member handle : felt
	    member image_uri : felt
	    member follow_module : felt
	    member follow_module_init_data : felt
	    member follow_nft_uri : felt
	end

	struct SetDefaultProfileWithSigData:
	    member wallet : felt
    	member profile_id : Uint256
	    member sig : EIP712Signature
	end

	struct SetFollowModuleWithSigData:
	    member profile_id : Uint256
	    member follow_module : felt
	    member follow_module_init_data : felt
	    member sig : EIP712Signature
	end

	struct SetDispatcherWithSigData:
	    member profile_id : Uint256
	    member dispatcher : felt
	    member sig : EIP712Signature
	end

	struct SetProfileImageURIWithSigData:
	    member profile_id : Uint256
	    member image_uri : felt
	    member sig : EIP712Signature
	end

	struct SetFollowNFTURIWithSigData:
    	member profile_id : Uint256
	    member follow_nft_uri : felt
	    member sig : EIP712Signature
	end

	struct PostData:
	    member profile_id : Uint256
	    member content_uri : felt
	    member collect_module : felt
	    member collect_module_init_data : felt
	    member reference_module : felt
	    member reference_module_init_data : felt
	end

	struct PostWithSigData:
	   	member profile_id : Uint256
    	member content_uri : felt
	    member collect_module : felt
    	member collect_module_init_data : felt
	    member reference_module : felt
	    member reference_module_init_data : felt
	    member sig : EIP712Signature
	end

	struct CommentData:
	    member profile_id : Uint256
	    member content_uri : felt
	    member profile_id_pointed : Uint256
	    member pub_id_pointed : Uint256
	    member reference_module_data : felt
	    member collect_module : felt
	    member collect_module_init_data : felt
	    member reference_module : felt
	    member reference_module_init_data : felt
	end

	struct CommentWithSigData:
	    member profile_id : Uint256
	    member content_uri : felt
	    member profile_id_pointed : Uint256
	    member pub_id_pointed : Uint256
	    member reference_module_data : felt
	    member collect_module : felt
	    member collect_module_init_data : felt
	    member reference_module : felt
    	member reference_module_init_data : felt
	    member sig : EIP712Signature
	end

	struct MirrorData:
	    member profile_id : Uint256
    	member profile_id_pointed : Uint256
	    member pub_id_pointed : Uint256
    	member reference_odule_data : felt
	    member reference_module : felt
	    member reference_module_init_data : felt
	end

	struct MirrorWithSigData:
	    member profile_id : Uint256
	    member profile_id_pointed : Uint256
	    member pub_id_pointed : Uint256
	    member reference_module_data : felt
	    member reference_module : felt
	    member reference_module_init_data : felt
	    member sig : EIP712Signature
	end

	struct FollowWithSigData:
	    member follower : felt
	    member profile_ids : felt
	    member datas : felt
    	member sig : EIP712Signature
	end

	struct CollectWithSigData:
	    member collector : felt
    	member profile_id : Uint256
	    member pub_id : Uint256
	    member data : felt
    	member sig : EIP712Signature
	end

	struct SetProfileMetadataWithSigData:
    	member profile_id : Uint256
	    member metadata : felt
	    member sig : EIP712Signature
	end

	struct ToggleFollowWithSigData:
	    member follower : felt
    	member profile_ids : felt
	    member enables : felt
	    member sig : EIP712Signature
	end


	# * @notice Contains the owner address and the mint timestamp for every NFT.
	# *
	# * Note: Instead of the owner address in the _tokenOwners private mapping, we now store it in the
	# * _tokenData mapping, alongside the unchanging mintTimestamp.
	# *
	# * @param owner The token owner.
	# * @param mint_timestamp The mint timestamp.
	struct TokenData:
      	    member owner : felt
	    member mint_timestamp : felt
	end
end
