// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BondingCurve.sol";

contract BondingCurveSellTest is Test {
    BondingCurve curve;

    function setUp() public {
        curve = new BondingCurve(1, 1);
    }

    function test_RevertSellMoreThanSupply() public {
        vm.expectRevert(BondingCurve.NoSupply.selector);
        curve.sell(1);
    }
}
