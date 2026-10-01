use starknet::ContractAddress;
use zkgraph_protocol::profile::IProfileNFT;
use zkgraph_protocol::follow::IFollowNFT;
use zkgraph_protocol::posts::IPosts;
use zkgraph_protocol::mocks::MockRandomGenerator;

#[starknet::test]
fn test_end_to_end_user_journey() {
    // 1. Setup: Deploy Mocks and Core Contracts
    let random_gen = deploy_contract::<MockRandomGenerator>();
    random_gen.set_random_value(12345); // Ensure determinism

    let profile_nft = deploy_contract::<ProfileNFT>(random_gen);
    let follow_nft = deploy_contract::<FollowNFT>(profile_nft, random_gen);
    let posts_contract = deploy_contract::<Posts>(profile_nft);

    let user_a = ContractAddress::from_number(1);
    let user_b = ContractAddress::from_number(2);

    // 2. Create Profile NFTs
    profile_nft.create_profile(user_a, "Alice");
    profile_nft.create_profile(user_b, "Bob");

    assert(profile_nft.get_profile_id(user_a) != 0, 'User A profile should exist');
    assert(profile_nft.get_profile_id(user_b) != 0, 'User B profile should exist');

    // 3. User A follows User B
    // This should trigger the minting of a Follow NFT
    follow_nft.follow(user_a, user_b);

    let follow_token_id = follow_nft.get_follow_token_id(user_a, user_b);
    assert(follow_token_id != 0, 'Follow NFT should be minted');

    // 4. User A creates a post
    let post_content = "Hello ZK-Graph!";
    posts_contract.create_post(user_a, post_content);

    let post_id = posts_contract.get_last_post_id(user_a);
    assert(posts_contract.get_post_content(post_id) == post_content, 'Post content mismatch');
}
