// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/access/Allowlist.sol";

contract AllowlistTest is Test {
    Allowlist list;

    function setUp() public {
        list = new Allowlist();
    }

    function test_BulkSet() public {
        address[] memory addrs = new address[](3);
        addrs[0] = address(0x1);
        addrs[1] = address(0x2);
        addrs[2] = address(0x3);
        list.setMany(addrs, true);
        assertTrue(list.isAllowed(address(0x2)));
        assertEq(list.totalAllowed(), 3);
    }

    function test_Revoke() public {
        list.setAllowed(address(0x9), true);
        list.setAllowed(address(0x9), false);
        assertFalse(list.isAllowed(address(0x9)));
        assertEq(list.totalAllowed(), 0);
    }
}
