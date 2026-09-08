// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Staking
/// @notice Stake ERC20 and accrue rewards per-second at a fixed rate.
contract Staking is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable stakeToken;
    IERC20 public immutable rewardToken;

    uint256 public rewardRate;   // reward per stake-second
    uint256 public totalStaked;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public lastUpdate;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor(address stakeToken_, address rewardToken_) Ownable(msg.sender) {
        stakeToken = IERC20(stakeToken_);
        rewardToken = IERC20(rewardToken_);
    }

    function setRewardRate(uint256 rate) external onlyOwner {
        rewardRate = rate;
    }

    function accrued(address user) public view returns (uint256) {
        return (balanceOf[user] * rewardRate * (block.timestamp - lastUpdate[user])) / 1e18;
    }

    function stake(uint256 amount) external nonReentrant {
        if (balanceOf[msg.sender] > 0) {
            _claim(msg.sender);
        }
        stakeToken.safeTransferFrom(msg.sender, address(this), amount);
        balanceOf[msg.sender] += amount;
        totalStaked += amount;
        lastUpdate[msg.sender] = block.timestamp;
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(amount <= balanceOf[msg.sender], "insufficient");
        _claim(msg.sender);
        balanceOf[msg.sender] -= amount;
        totalStaked -= amount;
        lastUpdate[msg.sender] = block.timestamp;
        stakeToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    function claimRewards() external nonReentrant {
        _claim(msg.sender);
        lastUpdate[msg.sender] = block.timestamp;
    }

    function _claim(address user) private {
        uint256 r = accrued(user);
        if (r > 0) {
            rewardToken.safeTransfer(user, r);
            emit RewardsClaimed(user, r);
        }
    }
}
