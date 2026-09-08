// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC20.sol";
import "../src/Staking.sol";

contract StakingTest is Test {
    BaseERC20 stake;
    BaseERC20 reward;
    Staking pool;

    function setUp() public {
        stake = new BaseERC20("Stake", "STK", 18, 1e24);
        reward = new BaseERC20("Reward", "RWD", 18, 1e24);
        pool = new Staking(address(stake), address(reward));
        pool.setRewardRate(1e18); // 1 reward token per staked-token-second
        stake.mint(address(this), 100e18);
        reward.mint(address(pool), 1e24);
        stake.approve(address(pool), type(uint256).max);
    }

    function test_AccrualOverTime() public {
        pool.stake(10e18);
        vm.warp(block.timestamp + 100);
        pool.claimRewards();
        assertEq(reward.balanceOf(address(this)), 1000e18);
    }
}
