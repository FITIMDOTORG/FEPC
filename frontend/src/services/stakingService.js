import { ethers } from "ethers";
import stakingABI from "../abis/StakingContract.json";

const stakingContractAddress = "0xYourStakingContractAddress";

export const getStakingContract = () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    return new ethers.Contract(stakingContractAddress, stakingABI, provider);
};

export const stakeTokens = async (amount) => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(stakingContractAddress, stakingABI, signer);
    const tx = await contract.stake({ value: ethers.utils.parseEther(amount) });
    await tx.wait();
};

export const claimRewards = async () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(stakingContractAddress, stakingABI, signer);
    const tx = await contract.claimReward();
    await tx.wait();
};
