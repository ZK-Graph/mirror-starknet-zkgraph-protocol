import { Contract, Account, Provider } from 'starknet.js';

const PROFILE_CONTRACT_ADDRESS = '0x...'; // Endereço a ser configurado via env
const FOLLOW_CONTRACT_ADDRESS = '0x...';  // Endereço a ser configurado via env

export const starknetService = {
    async createProfile(account: Account, handle: string, imageUri: string, followNftUri: string) {
        const profileContract = new Contract(PROFILE_CONTRACT_ADDRESS, account);
        // Chamada para a função de mint do Profile NFT
        return await profileContract.execute('mint_profile', {
            handle,
            image_uri: imageUri,
            follow_nft_uri: followNftUri
        });
    },

    async followProfile(account: Account, profileId: number) {
        const followContract = new Contract(FOLLOW_CONTRACT_ADDRESS, account);
        // Chamada para a função de mint do Follow NFT
        return await followContract.execute('follow', {
            profile_id: profileId
        });
    },

    async getProfiles(provider: Provider) {
        const profileContract = new Contract(PROFILE_CONTRACT_ADDRESS, provider);
        // Assume-se a existência de uma função de listagem ou indexador
        // Para fins de implementação, simulamos a chamada de getter de lista
        const profiles = await profileContract.call('get_all_profiles');
        return profiles;
    },

    async checkHandleAvailability(provider: Provider, handle: string) {
        const profileContract = new Contract(PROFILE_CONTRACT_ADDRESS, provider);
        // Utiliza a lógica de InteractionLogic.cairo via contrato
        const isAvailable = await profileContract.call('is_handle_available', { handle });
        return isAvailable;
    }
};
