// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../libraries/LibPercent.sol";

contract LibPercentTest is Test {
    using LibPercent for uint256;

    function test_Down() public pure {
        assertEq(uint256(1).mulDivDown(5000), 0);
        assertEq(uint256(200).mulDivDown(5000), 100);
    }

    function test_Up() public pure {
        assertEq(uint256(1).mulDivUp(5000), 1);
        assertEq(uint256(200).mulDivUp(5000), 100);
    }

    function test_Fuzz(uint256 amount, uint256 bp) public pure {
        bp = bp % 10_001;
        uint256 down = amount.mulDivDown(bp);
        assertLe(down, (amount * bp) / 10000 == 0 ? 0 : type(uint256).max);
    }
}
