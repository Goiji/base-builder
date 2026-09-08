// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BondingCurve.sol";

contract BondingCurveTest is Test {
    BondingCurve curve;

    function setUp() public {
        curve = new BondingCurve(1 ether / 1000, 0.0001 ether);
    }

    function test_BuyAndSell() public {
        uint256 cost = curve.buyCost(10);
        vm.deal(address(this), 100 ether);
        curve.buy{ value: cost }(10);
        assertEq(curve.totalSupply(), 10);
        uint256 proceeds = curve.sellProceeds(10);
        // proceeds <= what was paid due to the linear (not strictly convex) model
        assertLe(proceeds, cost);
        curve.sell(10);
        assertEq(curve.totalSupply(), 0);
    }
}
