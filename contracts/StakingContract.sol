// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakingContract {
    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewardDebt;
    uint256 public totalStaked;
    uint256 public rewardPerTokenStored;
    uint256 public lastUpdateTime;
    uint256 public rewardRate = 1e18; // Example: 1 FEPC reward per second

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        if (account != address(0)) {
            rewardDebt[account] = earned(account);
        }
        _;
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored +
            ((block.timestamp - lastUpdateTime) * rewardRate * 1e18) /
            totalStaked;
    }

    function earned(address account) public view returns (uint256) {
        return
            (stakes[account] * (rewardPerToken() - rewardDebt[account])) /
            1e18;
    }

    function stake() external payable updateReward(msg.sender) {
        require(msg.value > 0, "Stake amount must be greater than 0");
        stakes[msg.sender] += msg.value;
        totalStaked += msg.value;
        emit Staked(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external updateReward(msg.sender) {
        require(stakes[msg.sender] >= amount, "Insufficient stake balance");
        stakes[msg.sender] -= amount;
        totalStaked -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function claimReward() external updateReward(msg.sender) {
        uint256 reward = earned(msg.sender);
        require(reward > 0, "No rewards to claim");
        rewardDebt[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
        emit RewardPaid(msg.sender, reward);
    }
}
