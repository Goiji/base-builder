// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC721Metadata.sol";

contract BaseERC721MetadataTest is Test {
    BaseERC721Metadata nft;

    function setUp() public {
        nft = new BaseERC721Metadata("Meta", "MET", "ipfs://base/", 10, 0.001 ether);
    }

    function test_DefaultTokenURIUsesBase() public {
        nft.ownerMint(address(this));
        assertEq(nft.tokenURI(1), "ipfs://base/1");
    }

    function test_ExplicitTokenURIWins() public {
        nft.ownerMint(address(this));
        nft.setTokenURI(1, "ipfs://custom/1");
        assertEq(nft.tokenURI(1), "ipfs://custom/1");
    }
}
