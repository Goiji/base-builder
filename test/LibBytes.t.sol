// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../libraries/LibBytes.sol";

contract LibBytesTest is Test {
    function test_TrimZeros() public pure {
        bytes memory input = abi.encodePacked(bytes1(0x00), bytes1(0x00), bytes1(0xAB));
        bytes memory out = LibBytes.trim(input);
        assertEq(out.length, 1);
        assertEq(out[0], bytes1(0xAB));
    }

    function test_NoLeadingZeros() public pure {
        bytes memory input = abi.encodePacked(bytes1(0xAB), bytes1(0xCD));
        bytes memory out = LibBytes.trim(input);
        assertEq(out.length, 2);
    }
}
