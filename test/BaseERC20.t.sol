// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC20.sol";

contract BaseERC20Test is Test {
    BaseERC20 token;

    function setUp() public {
        token = new BaseERC20("Base Coin", "BASE", 18, 1_000_000e18);
    }

    function test_Metadata() public view {
        assertEq(token.name(), "Base Coin");
        assertEq(token.symbol(), "BASE");
        assertEq(token.decimals(), 18);
    }

    function test_MintByOwner() public {
        token.mint(address(0xBEEF), 100e18);
        assertEq(token.balanceOf(address(0xBEEF)), 100e18);
        assertEq(token.totalSupply(), 100e18);
    }

    function test_RevertMintOverCap() public {
        token.mint(address(this), 1_000_001e18);
    }

    function test_RevertMintByNonOwner() public {
        vm.prank(address(0x1234));
        token.mint(address(0x1234), 1);
    }

    function test_Burn() public {
        token.mint(address(this), 50e18);
        token.burn(address(this), 20e18);
        assertEq(token.balanceOf(address(this)), 30e18);
    }

    function test_PauseBlocksTransfer() public {
        token.mint(address(this), 10e18);
        token.pause();
        vm.expectRevert();
        token.transfer(address(0x999), 1);
        token.unpause();
        token.transfer(address(0x999), 1);
        assertEq(token.balanceOf(address(0x999)), 1);
    }

    receive() external payable {}
}
