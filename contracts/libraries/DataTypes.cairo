#import "starknet";

struct ProfileStruct {
    member image_uri: ByteArray,
    member bio: felt252,
}

struct PublicationStruct {
    member content_uri: ByteArray,
    member timestamp: felt252,
}
