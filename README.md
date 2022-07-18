# ZK Social Graph

## About

ZK Social Graph is a Web3, Lens Protocol compatible smart contracts-based social graph for the StarkNet Ecosystem designed to empower creators to own the links between themselves and their community, forming a fully composable, user-owned social graph. The protocol is built from the ground up with modularity in mind, allowing new features to be added while ensuring immutable user-owned content and social relationships.

Our goal is to build Lens Protocol compatible StarkNet network based Social Graph and appropriate APIs enhanced with ZK security features.

Lens Protocol overview: https://docs.lens.xyz/docs 

## StarkNet for Social Graphs?

1. ZK Security
2. L2 scaling capabilities
3. Reduced fees
2. Allow more people to interact / benefit from Social Graph (like Lens) ecosystem (we expect that there will be a way to use data from other chains)
3. Speed is another big one, Polygon is actually quite slow and clogs easily

![ZK Social Graph - Overview](https://gitlab.com/zk-social-graph/starknet-social-graph/-/raw/main/assets/ZK_Social_Graph_-_Overview.png )

## Profiles

```
ZK Social Graph is 100% compatible with Lens Protocol. 
```

Any address can create a profile and receive an ERC-721 ZK Social Graph Profile NFT. Profiles are represented by a ProfileStruct:

```
# A struct containing profile data.
#
# pubCount The number of publications made to this profile.
# followNFT The address of the followNFT associated with this profile, can be empty..
# followModule The address of the current follow module in use by this profile, can be empty.
# handle The profile's associated handle.
# uri The URI to be displayed for the profile NFT.

struct ProfileStruct:
    member pubCount: Uint256
    member followNFT: felt
    member followModule: felt
    member handle: felt
    member uri: felt
end
```

Profiles have a specific URI associated with them, which is meant to include metadata, such as a link to a profile picture or a display name for instance, the JSON standard for this URI is not yet determined. Profile owners can always change their follow module or profile URI.

## Publications

Profile owners can `publish` to any profile they own. There are three `publication` types: `Post`, `Comment` and `Mirror`. Profile owners can also set and initialize the `Follow Module` associated with their profile.

Publications are on-chain content created and published via profiles. Profile owners can create (publish) three publication types, outlined below. They are represented by a `PublicationStruct`:

```
# A struct containing data associated with each new publication.

# profileIdPointed The profile token ID this publication points to, for mirrors and comments.
# pubIdPointed The publication ID this publication points to, for mirrors and comments.
# contentURI The URI associated with this publication.
# referenceModule The address of the current reference module in use by this profile, can be empty.
# collectModule The address of the collect module associated with this publication, this exists for all publication.
# collectNFT The address of the collectNFT associated with this publication, if any.

struct PublicationStruct:
    member profileIdPointed: Uint256
    member pubIdPointed: Uint256
    member contentURI: felt
    member referenceModule: felt
    member collectModule: felt
    member collectNFT: felt
end

```

### Profile Interaction

There are two types of profile interactions: follows and collects.

#### Follows

Wallets can follow profiles, executing modular follow processing logic (in that profile's selected follow module) and receiving a `Follow NFT`. Each profile has a connected, unique `FollowNFT` contract, which is first deployed upon successful follow. Follow NFTs are NFTs with integrated voting and delegation capability.

#### Collects

Collecting works in a modular fashion as well, every publication (except mirrors) requires a `Collect Module` to be selected and initialized. This module, similarly to follow modules, can contain any arbitrary logic to be executed upon collects. Successful collects result in a new, unique NFT being minted, essentially as a saved copy of the original publication. There is one deployed collect NFT contract per publication, and it's deployed upon the first successful collect.

## ZK Social Graph Modularity

Stepping back for a moment, the core concept behind modules is to allow as much freedom as possible to the community to come up with new, innovative interaction mechanisms between social graph participants. For security purposes, this is achieved by including a whitelisted list of modules controlled by governance.

## Security and Privacy concerns

https://gitlab.com/zk-graph/starknet-zkgraph-protocol/-/blob/main/security_overview.md 

### Concerns

In the next decade, web services will evolve to become truly personal, living in more places than just user's browser, and reason over every intimate detail of our personal lives. There are examples to demonstrate this already. For example, in the past five years, the number of in-home smart assistants has grown from zero to half a billion web-connected devices. Our private lives have become a public commodity and as web services evolve to become more personal, we need to rethink how we control our data.

### Pseudonymously 

... with zero knowledge verified Profile NFTs. This means user can prove credentials, ownership, or facts without them tracing back to user.
ZK Social Graph project goal is to extend Lens Protocol with pseudonymous Profile NFT ownership (ZK badges). This means user can prove ownership of an  Profile NFT without it tracing back to him.

#### ZK Proof

In user's wallet(s), he has NFTs that can point back to his identity (aka, getting doxxed). User can verify ownership of NFTs while staying pseudonymous.
When user connect his wallet(s), we verify his NFTs. Then, we create ZK badges out of them.

https://youtu.be/_0F4QP5rJ_Q?t=3186 

#### ZK badges

This means user can prove ownership of an NFT without it tracing back to user.

#### Building user identities (Profile NFTs) with ZK Badges

Once user has ZK proof, user can add/create ZK badges for an anonymous wallet.
Zk badges verify user owns an NFT but leaves no bread crumbs back to his personal wallets.

## How to run code
1. Setup the environment https://starknet.io/docs/quickstart.html
2. `pip3 install cairo-nile`
3. `git clone https://gitlab.com/zk-graph/starknet-zkgraph-protocol`
4. `cd starknet-zkgraph-protocol`
5. `nile init`
6. `nile compile`

## Milestones

1. Core (upgradable proxy pattern StarkWare equivalents, settings, basic security components)
2. Profile NFT
3. Follow module
4. Publication NFT
5. Reference Module
6. Collect Module
7. ZK Proofs to create private profiles
8. Indexer(s)
9. GraphQL APIs
