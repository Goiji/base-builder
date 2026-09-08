// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/registry/ContractRegistry.sol";

contract ContractRegistryTest is Test {
    ContractRegistry reg;

    function setUp() public {
        reg = new ContractRegistry();
    }

    function test_RegisterAndGet() public {
        reg.register("router", address(0x123));
        assertEq(reg.get("router"), address(0x123));
    }

    function test_NonAdminCannotRegister() public {
        vm.prank(address(0xBAD));
        vm.expectRevert();
        reg.register("x", address(0x999));
    }
}
