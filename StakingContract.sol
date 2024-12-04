// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakingContract {
    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewardDebt;
    uint256 public totalStaked;
    uint256 public rewardPerTokenStored;
    uint256 public lastUpdateTime;
    uint256 public rewardRate = 1e18; // Beispiel: 1 FEPC pro Sekunde

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        if (account != address(0)) {
            rewardDebt[account] = earned(account);
            stakes[account] = stakes[account];
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
            (stakes[account] *
                (rewardPerToken() - rewardDebt[account])) /
            1e18;
    }

    function stake(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Betrag muss größer als 0 sein");
        totalStaked += amount;
        stakes[msg.sender] += amount;
        // Transfer der Tokens vom Nutzer zum Vertrag
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) public updateReward(msg.sender) {
        require(amount > 0, "Betrag muss größer als 0 sein");
        totalStaked -= amount;
        stakes[msg.sender] -= amount;
        // Transfer der Tokens vom Vertrag zum Nutzer
        emit Withdrawn(msg.sender, amount);
    }

    function getReward() public updateReward(msg.sender) {
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            rewardDebt[msg.sender] = 0;
            // Transfer der Belohnung vom Vertrag zum Nutzer
            emit RewardPaid(msg.sender, reward);
        }
    }

    function exit() external {
        withdraw(stakes[msg.sender]);
        getReward();
    }
}
