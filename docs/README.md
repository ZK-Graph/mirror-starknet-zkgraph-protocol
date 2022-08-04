# Core functions

## Publishing Logic Library

### Create Profile
This a helper function that will be called directly from Hub (Main entrypoint)
It takes 3 parameters: 
- vars : DataTypes.CreateProfileData - struct containing data 
- profile_id : Uint256               - ID of profile that will be created

`vars` is a struct:
```
struct CreateProfileData:
    member to                      - The address receiving the profile.
    member handle                  - The handle to set for the profile, must be unique and non-empty.
    member image_uri               - The URI to set for the profile image.
    member follow_module           - The follow module to use, can be the zero address.
    member follow_module_init_data - The follow module initialization data, if any.
    member follow_nft_uri          - The URI to use for the follow NFT.
end
```
`profile_id` - ID of profile that will be created.


