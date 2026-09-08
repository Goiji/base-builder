// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC20.sol";
import "../src/TokenVesting.sol";

contract TokenVestingTest is Test {
    BaseERC20 token;
    TokenVesting vesting;
    address constant BENEFICIARY = address(0xCAFE);

    function setUp() public {
        token = new BaseERC20("Vested", "VST", 18, 1e24);
        uint256 start = block.timestamp;
        vesting = new TokenVesting(address(token), BENEFICIARY, start, 30 days, 360 days);
        token.mint(address(vesting), 1_000e18);
    }

    function test_CliffBlocksEarlyRelease() public {
        vm.warp(block.timestamp + 10 days);
        vm.prank(BENEFICIARY);
        vm.expectRevert();
        vesting.release();
    }

    function test_LinearReleaseHalfway() public {
        vm.warp(block.timestamp + 180 days + 1);
        vm.prank(BENEFICIARY);
        vesting.release();
        // ~half released after half the duration past the cliff
        uint256 bal = token.balanceOf(BENEFICIARY);
        assertApproxEqRel(bal, 500e18, 0.01e18);
    }

    function test_FullReleaseAtEnd() public {
        vm.warp(block.timestamp + 390 days);
        vm.prank(BENEFICIARY);
        vesting.release();
        assertEq(token.balanceOf(BENEFICIARY), 1_000e18);
    }
}
