// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BuybackERC20.sol";

contract BuybackERC20Test is Test {
    BuybackERC20 token;

    function setUp() public {
        token = new BuybackERC20("BB", "BB", 18, 1e24, 1000); // 10% burn
        token.mint(address(this), 1000e18);
    }

    function test_BurnOnTransfer() public {
        token.transfer(address(0xABC), 100e18);
        // 90e18 arrives, 10e18 burned
        assertEq(token.balanceOf(address(0xABC)), 90e18);
        assertEq(token.totalSupply(), 900e18);
    }
}
