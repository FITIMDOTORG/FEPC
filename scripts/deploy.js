const { ethers } = require("hardhat");

async function main() {
    const StakingContract = await ethers.getContractFactory("StakingContract");
    const staking = await StakingContract.deploy();
    await staking.deployed();
    console.log("StakingContract deployed to:", staking.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
