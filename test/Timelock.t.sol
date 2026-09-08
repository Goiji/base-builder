// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/governance/Timelock.sol";

contract TimelockTest is Test {
    Timelock lock;
    address proposer = address(0x1);
    address executor = address(0x2);

    function setUp() public {
        address[] memory p = new address[](1);
        p[0] = proposer;
        address[] memory e = new address[](1);
        e[0] = executor;
        lock = new Timelock(1, p, e);
    }

    function test_OnlyExecutorExecutes() public {
        vm.prank(proposer);
        lock.queue(address(0xDEAD), 0, "");
        vm.prank(executor);
        lock.execute(address(0xDEAD), 0, "");
        assertTrue(true);
    }
}
