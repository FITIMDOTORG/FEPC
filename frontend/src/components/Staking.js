import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import stakingABI from "../abis/StakingContract.json";

const Staking = () => {
    const [stakeAmount, setStakeAmount] = useState("");
    const [reward, setReward] = useState(0);
    const [totalStaked, setTotalStaked] = useState(0);

    const stakingContractAddress = "0xYourStakingContractAddress";

    useEffect(() => {
        fetchTotalStaked();
    }, []);

    const fetchTotalStaked = async () => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = new ethers.Contract(stakingContractAddress, stakingABI, provider);
        const total = await contract.totalStaked();
        setTotalStaked(ethers.utils.formatEther(total));
    };

    const handleStake = async () => {
        if (!stakeAmount) return;
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(stakingContractAddress, stakingABI, signer);
        const tx = await contract.stake({ value: ethers.utils.parseEther(stakeAmount) });
        await tx.wait();
        fetchTotalStaked();
        alert("Stake successful!");
    };

    const handleClaimReward = async () => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(stakingContractAddress, stakingABI, signer);
        const tx = await contract.claimReward();
        await tx.wait();
        alert("Reward claimed!");
    };

    return (
        <div>
            <h1>FEPCoin Staking</h1>
            <p>Total Staked: {totalStaked} FEPC</p>
            <input
                type="number"
                placeholder="Amount to Stake"
                value={stakeAmount}
                onChange={(e) => setStakeAmount(e.target.value)}
            />
            <button onClick={handleStake}>Stake</button>
            <button onClick={handleClaimReward}>Claim Rewards</button>
        </div>
    );
};

export default Staking;
