%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin


namespace DataTypes {
	struct EIP712Signature {
    	    v : felt,
	    r : Uint256,
	    s : Uint256,
	    deadline: Uint256,
	}

	struct ProfileStruct {
	    pub_count : Uint256,
	    follow_module : felt,
	    follow_nft : felt,
	    handle : felt,
	    image_uri : felt,
	    follow_nft_uri : felt,
	}

	struct PublicationStruct {
	    profile_id_pointed : Uint256,
	    pub_id_pointed : Uint256,
	    content_uri : felt,
	}

	struct CreateProfileData {
    	    to : felt,
	    handle : felt,
	    image_uri : felt,
	    follow_module : felt,
	    follow_module_init_data : felt,
	    follow_nft_uri : felt,
	}

	struct SetDefaultProfileWithSigData {
	    wallet : felt,
    	    profile_id : Uint256,
	    sig : EIP712Signature,
	}

	struct SetFollowModuleWithSigData {
	    profile_id : Uint256,
	    follow_module : felt,
	    follow_module_init_data : felt,
	    sig : EIP712Signature,
	}

	struct SetDispatcherWithSigData {
	    profile_id : Uint256,
	    dispatcher : felt,
	    sig : EIP712Signature,
	}

	struct SetProfileImageURIWithSigData {
	    profile_id : Uint256,
	    image_uri : felt,
	    sig : EIP712Signature,
	}

	struct SetFollowNFTURIWithSigData {
    	    profile_id : Uint256,
	    follow_nft_uri : felt,
            sig : EIP712Signature,
	}

	struct PostData {
	    profile_id : Uint256,
	    content_uri : felt,
	    collect_module : felt,
	    collect_module_init_data : felt,
	    reference_module : felt,
	    reference_module_init_data : felt,
	}

	struct PostWithSigData {
	    profile_id : Uint256,
    	    content_uri : felt,
	    collect_module : felt,
    	    collect_module_init_data : felt,
            reference_module : felt,
	    reference_module_init_data : felt,
	    sig : EIP712Signature,
	}

	struct CommentData {
	    profile_id : Uint256,
	    content_uri : felt,
	    profile_id_pointed : Uint256,
	    pub_id_pointed : Uint256,
	    reference_module_data : felt,
	    collect_module : felt,
	    collect_module_init_data : felt,
	    reference_module : felt,
	    reference_module_init_data : felt,
	}

	struct CommentWithSigData {
	    profile_id : Uint256,
	    content_uri : felt,
	    profile_id_pointed : Uint256,
	    pub_id_pointed : Uint256,
	    reference_module_data : felt,
	    collect_module : felt,
	    collect_module_init_data : felt,
	    reference_module : felt,
    	    reference_module_init_data : felt,
	    sig : EIP712Signature,
	}

	struct MirrorData {
	    profile_id : Uint256,
    	    profile_id_pointed : Uint256,
            pub_id_pointed : Uint256,
    	    reference_odule_data : felt,
	    reference_module : felt,
	    reference_module_init_data : felt,
	}

	struct MirrorWithSigData {
            profile_id : Uint256,
	    profile_id_pointed : Uint256,
	    pub_id_pointed : Uint256,
	    reference_module_data : felt,
	    reference_module : felt,
	    reference_module_init_data : felt,
	    sig : EIP712Signature,
	}

	struct FollowWithSigData {
	    follower : felt,
	    profile_ids : felt,
	    datas : felt,
    	    sig : EIP712Signature,
	}

	struct CollectWithSigData {
	    collector : felt,
    	    profile_id : Uint256,
	    pub_id : Uint256,
	    data : felt,
    	    sig : EIP712Signature,
        }

	struct SetProfileMetadataWithSigData {
    	    profile_id : Uint256,
	    metadata : felt,
	    sig : EIP712Signature,
	}

	struct ToggleFollowWithSigData {
	    follower : felt,
    	    profile_ids : felt,
	    enables : felt,
	    sig : EIP712Signature,
	}


	// * @notice Contains the owner address and the mint timestamp for every NFT.
	// *
	// * Note: Instead of the owner address in the _tokenOwners private mapping, we now store it in the
	// * _tokenData mapping, alongside the unchanging mintTimestamp.
	// *
	// * @param owner The token owner.
	// * @param mint_timestamp The mint timestamp.
	struct TokenData {
      	    owner : felt,
	    mint_timestamp : felt,
	}
}
