use zkgraph_protocol::libraries::InteractionLogic;

#[starknet::test]
fn test_interaction_weight_calculation() {
    let weight = InteractionLogic::calculate_weight(10, 2); // example params
    assert(weight > 0, 'Weight should be positive');
}
