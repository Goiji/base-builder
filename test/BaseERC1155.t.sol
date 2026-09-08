// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC1155.sol";

contract BaseERC1155Test is Test {
    BaseERC1155 nft;

    function setUp() public {
        nft = new BaseERC1155("ipfs://{id}.json");
    }

    function test_MintIncreasesSupply() public {
        nft.mint(address(0xAAA), 1, 5, "");
        assertEq(nft.balanceOf(address(0xAAA), 1), 5);
        assertEq(nft.totalSupply(1), 5);
    }

    function test_EmptyMintIsFine() public {
        nft.mint(address(0xAAA), 2, 0, "");
        assertEq(nft.totalSupply(2), 0);
    }
}
