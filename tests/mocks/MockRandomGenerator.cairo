#[starknet::interface]
trait IRandomGenerator {
    fn get_random_number(self: ContractState) -> u256;
}

#[starknet::contract]
mod MockRandomGenerator {
    use super::IRandomGenerator;
    #[storage]
    struct Storage {
        random_value: u256,
    }

    #[external(v0)]
    impl IRandomGeneratorImpl of IRandomGenerator {
        fn get_random_number(self: ContractState) -> u256 {
            self.random_value.read()
        }
    }

    #[external(v0)]
    fn set_random_value(ref self: ContractState, value: u256) {
        self.random_value.write(value);
    }
}
