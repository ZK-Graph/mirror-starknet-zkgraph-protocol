import React, { useState, useEffect } from 'react';
import { starknetService } from '../services/starknetService';

export const ProfileManager = ({ account, provider }: { account: any, provider: any }) => {
    const [handle, setHandle] = useState('');
    const [imageUri, setImageUri] = useState('');
    const [followUri, setFollowUri] = useState('');
    const [profiles, setProfiles] = useState([]);
    const [loading, setLoading] = useState(false);

    const loadProfiles = async () => {
        const data = await starknetService.getProfiles(provider);
        setProfiles(data);
    };

    useEffect(() => { loadProfiles(); }, []);

    const handleCreateProfile = async () => {
        setLoading(true);
        try {
            const available = await starknetService.checkHandleAvailability(provider, handle);
            if (!available) throw new Error("Handle already taken");
            
            await starknetService.createProfile(account, handle, imageUri, followUri);
            alert("Profile created successfully!");
            loadProfiles();
        } catch (e: any) {
            alert(e.message);
        } finally {
            setLoading(false);
        }
    };

    const handleFollow = async (profileId: number) => {
        try {
            await starknetService.followProfile(account, profileId);
            alert("Following profile!");
        } catch (e: any) {
            alert("Error following profile");
        }
    };

    return (
        <div className="p-4">
            <section className="mb-8 border p-4 rounded">
                <h2>Create Profile NFT</h2>
                <input placeholder="Handle" onChange={e => setHandle(e.target.value)} className="block mb-2 p-2 border" />
                <input placeholder="Image URI" onChange={e => setImageUri(e.target.value)} className="block mb-2 p-2 border" />
                <input placeholder="Follow NFT URI" onChange={e => setFollowUri(e.target.value)} className="block mb-2 p-2 border" />
                <button onClick={handleCreateProfile} disabled={loading} className="bg-blue-500 text-white p-2 rounded">
                    {loading ? 'Processing...' : 'Mint Profile'}
                </button>
            </section>

            <section>
                <h2>Existing Profiles</h2>
                <div className="grid gap-4">
                    {profiles.map((p: any) => (
                        <div key={p.id} className="border p-2 flex justify-between items-center">
                            <span>{p.handle}</span>
                            <button onClick={() => handleFollow(p.id)} className="bg-green-500 text-white p-1 rounded">Follow</button>
                        </div>
                    ))}
                </div>
            </section>
        </div>
    );
};
