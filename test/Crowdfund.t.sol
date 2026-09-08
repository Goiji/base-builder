// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Crowdfund.sol";

contract CrowdfundTest is Test {
    Crowdfund fund;

    function setUp() public {
        fund = new Crowdfund(10 ether, 30 days);
    }

    function test_Contribute() public {
        vm.deal(address(0xABC), 5 ether);
        vm.prank(address(0xABC));
        fund.contribute{ value: 5 ether }();
        assertEq(fund.totalRaised(), 5 ether);
    }

    function test_CloseOnlyAfterDeadlineOrGoal() public {
        vm.deal(address(0xABC), 10 ether);
        vm.prank(address(0xABC));
        fund.contribute{ value: 10 ether }();
        fund.close();
        assertTrue(fund.closed());
    }

    function test_RefundWhenGoalMissed() public {
        vm.deal(address(0xABC), 2 ether);
        vm.prank(address(0xABC));
        fund.contribute{ value: 2 ether }();
        vm.warp(block.timestamp + 31 days);
        vm.prank(address(0xABC));
        fund.refund();
        assertEq(address(0xABC).balance, 2 ether);
    }
}
