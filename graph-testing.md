Hey StarkNet Community,

We deployed sample zkGraph smart contract to StarkNet testnet. Feel free to join and mint your Profile NFTs and follow other owners.

zkGraph is a Web3, Lens Protocol compatible smart contracts-based social graph for the StarkNet Ecosystem.

Contact us if any:
- Twitter: https://twitter.com/ZKGraph
- Telegram Group: https://t.me/+b9d7ytd9BQ5lZDA1

![zkGraph - Profile and Follow NFTs](https://gitlab.com/zk-graph/starknet-zkgraph-protocol/-/raw/main/assets/zkGraph_-_NFTs.png)

## 1. Check list of existing Profile NFT: 

MinsSquare:
https://mintsquare.io/collection/starknet-testnet/0x02fa23eb9ec2912d2b81c7c6c4380f20bc7c9490fe9056d33b784ae6d52e10a3/nfts

or Aspect:
https://testnet.aspect.co/collection/0x02fa23eb9ec2912d2b81c7c6c4380f20bc7c9490fe9056d33b784ae6d52e10a3

## 2. Mint your profile NFT

### a. Open contract page:
https://goerli.voyager.online/contract/0x02fa23eb9ec2912d2b81c7c6c4380f20bc7c9490fe9056d33b784ae6d52e10a3#writeContract

### b. Call `create_profile` functions with following parameters:

- create_profile_data.to - YOUR WALLET ADDRESS

- create_profile_data.handle - YOUR HANDLE (FOR EXAMPLE `hero.stark`). MAX 31 SYMBOLS.

Convert your handle string with https://gitlab.com/zk-graph/starknet-zkgraph-protocol/-/blob/main/utils.py 

```
print(str_to_felt("rustam.stark"))

$ python3 -i utils.py
```

or use 3rd party service to convert handle string to Hex.

https://www.rapidtables.com/convert/number/ascii-to-hex.html

![zkGraph - ASCII to Hex Converter](https://gitlab.com/zk-graph/starknet-zkgraph-protocol/-/raw/main/assets/ASCII_to_Hex_converter.png)

- create_profile_data.image_uri

We haven't implemented handler for image_uri yet, subsequently it can be ANY string no longer than 31 characters (for example you Handle). 

- create_profile_data.follow_module = 0 

Follow module hasn't been implemented yet. Transaction will proceed if the value is zero.
​
- create_profile_data.follow_module_init_data = 0

Follow module haven't been implemented yet. Transaction will proceed if the value is zero.
​
- create_profile_data.follow_nft_uri = 0
Handler for Follow NFT URI hasn't been implemented yet. It can be ANY string no longer than 31 characters. But we recommend to keep it as zero.

![zkGraph - create_profile input](https://gitlab.com/zk-graph/starknet-zkgraph-protocol/-/raw/main/assets/create_profile_input.png)

### c. Troubleshoot your transaction at
https://starktx.info/testnet/YOURTRANSACTIONID/

Make sure you find appropriate EVENT. Check profile_id and sender fields.
> ```0x5e50b057.ProfileCreated(profile_id={low=2, high=0}, sender=0x73830811f177594866961267ec46da9b224d08bedc9f7c8bbc2e7d98d950b1e, to=0x73830811f177594866961267ec46da9b224d08bedc9f7c8bbc2e7d98d950b1e, handle=35423280659516410475122356843, image_uri=35423280659516410475122356843, follow_module=0, follow_module_return_data=0, follow_nft_uri=0, timestamp=2022-09-10 15:05:15)```

- profile_id - your new Profile ID number

## 3. Follow other Profile NFTs

### a. Call `follow` function with `profile_id` parameter

Get available Profile ID numbers from https://mintsquare.io/collection/starknet-testnet/0x005e50b057250ae513e2b5ba77e377669f9e29d48ebd3a14e00b6b27aee0a61e/nfts

### b. Troubleshoot your transaction at
https://starktx.info/testnet/YOURTRANSACTIONID/

Make sure you find appropriate EVENT:
> ``` 0x5e50b057.Followed(follower=0x5120a9dcce39bd6057c1df312f36862718dabce1baf36bc6af468cd447d5638, profile_id={low=1, high=0}, folow_module_data=0, timestamp=2022-09-10 14:48:32) ```
- follower - your address
- profile_id - required Profile ID number
 
Thank you for your support!
