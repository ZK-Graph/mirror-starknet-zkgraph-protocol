%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin


struct EIP712Signature:
    member v : felt
    member r : Uint256
    member s : Uint256
    member deadline: Uint256
end

struct ProfileStruct:
    member pubCount : Uint256
    member followModule : felt
    member followNFT : felt
    member handle : felt
    member imageURI : felt
    member followNFTURI : felt
end

struct PublicationStruct:
    member profileIdPointed : Uint256
    member pubIdPointed : Uint256
    member contentURI : felt
    member referenceModule : felt
    member collectModule : felt
    member collectNFT : felt
end

struct CreateProfileData:
    member to : felt
    member handle : felt
    member imageURI : felt
    member followModule : felt
    member followModuleInitData : felt
    member followNFTURI : felt
end

struct SetDefaultProfileWithSigData:
    member wallet : felt
    member profileId : Uint256
    member sig : EIP712Signature
end

struct SetFollowModuleWithSigData:
    member profileId : Uint256
    member followModule : felt
    member followModuleInitData : felt
    member sig : EIP712Signature
end

struct SetDispatcherWithSigData:
    member profileId : Uint256
    member dispatcher : felt
    member sig : EIP712Signature
end

struct SetProfileImageURIWithSigData:
    member profileId : Uint256
    member imageURI : felt
    member sig : EIP712Signature
end

struct SetFollowNFTURIWithSigData:
    member profileId : Uint256
    member followNFTURI : felt
    member sig : EIP712Signature
end

struct PostData:
    member profileId : Uint256
    member contentURI : felt
    member collectModule : felt
    member collectModuleInitData : felt
    member referenceModule : felt
    member referenceModuleInitData : felt
end

struct PostWithSigData:
    member profileId : Uint256
    member contentURI : felt
    member collectModule : felt
    member collectModuleInitData : felt
    member referenceModule : felt
    member referenceModuleInitData : felt
    member sig : EIP712Signature
end

struct CommentData:
    member profileId : Uint256
    member contentURI : felt
    member profileIdPointed : Uint256
    member pubIdPointed : Uint256
    member referenceModuleData : felt
    member collectModule : felt
    member collectModuleInitData : felt
    member referenceModule : felt
    member referenceModuleInitData : felt
end

struct CommentWithSigData:
    member profileId : Uint256
    member contentURI : felt
    member profileIdPointed : Uint256
    member pubIdPointed : Uint256
    member referenceModuleData : felt
    member collectModule : felt
    member collectModuleInitData : felt
    member referenceModule : felt
    member referenceModuleInitData : felt
    member sig : EIP712Signature
end

struct MirrorData:
    member profileId : Uint256
    member profileIdPointed : Uint256
    member pubIdPointed : Uint256
    member referenceModuleData : felt
    member referenceModule : felt
    member referenceModuleInitData : felt
end

struct MirrorWithSigData:
    member profileId : Uint256
    member profileIdPointed : Uint256
    member pubIdPointed : Uint256
    member referenceModuleData : felt
    member referenceModule : felt
    member referenceModuleInitData : felt
    member sig : EIP712Signature
end

struct FollowWithSigData:
    member follower : felt
    member profileIds : felt
    member datas : felt
    member sig : EIP712Signature
end

struct CollectWithSigData:
    member collector : felt
    member profileId : Uint256
    member pubId : Uint256
    member data : felt
    member sig : EIP712Signature
end

struct SetProfileMetadataWithSigData:
    member profileId : Uint256
    member metadata : felt
    member sig : EIP712Signature
end

struct ToggleFollowWithSigData:
    member follower : felt
    member profileIds : felt
    member enables : felt
    member sig : EIP712Signature
end
