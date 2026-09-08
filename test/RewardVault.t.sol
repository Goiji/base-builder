// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC20.sol";
import "../src/RewardVault.sol";

contract RewardVaultTest is Test {
    BaseERC20 reward;
    BaseERC20 other;
    RewardVault vault;

    function setUp() public {
        reward = new BaseERC20("Rew", "RW", 18, 1e24);
        other = new BaseERC20("Oth", "OT", 18, 1e24);
        vault = new RewardVault(address(reward));
        reward.mint(address(vault), 100e18);
        other.mint(address(vault), 5e18);
    }

    function test_Drip() public {
        vault.drip(address(0x1), 40e18);
        assertEq(reward.balanceOf(address(0x1)), 40e18);
    }

    function test_SweepForeignToken() public {
        vault.sweep(other, 5e18);
        assertEq(other.balanceOf(address(this)), 5e18);
    }
}
