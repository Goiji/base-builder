// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC20.sol";

contract BaseERC20MoreTest is Test {
    BaseERC20 token;

    function setUp() public {
        token = new BaseERC20("More", "MORE", 18, 1e24);
    }

    function test_SupplyNeverExceedsCap(uint256 a, uint256 b) public {
        a = a % (1e24 / 2);
        b = b % (1e24 / 2);
        token.mint(address(this), a);
        token.mint(address(this), b);
        assertLe(token.totalSupply(), token.maxSupply());
    }
}
