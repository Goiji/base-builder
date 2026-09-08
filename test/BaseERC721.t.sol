// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC721.sol";

contract BaseERC721Test is Test {
    BaseERC721 nft;

    function setUp() public {
        nft = new BaseERC721("Base NFT", "BNFT", "ipfs://base/", 100, 0.01 ether);
    }

    function test_OwnerMint() public {
        uint256 id = nft.ownerMint(address(this));
        assertEq(id, 1);
        assertEq(nft.ownerOf(1), address(this));
    }

    function test_PublicMintRequiresPayment() public {
        vm.expectRevert();
        nft.publicMint(address(this));
    }

    function test_PublicMintPays() public {
        vm.prank(address(0xBEEF));
        uint256 id = nft.publicMint{ value: 0.01 ether }(address(0xBEEF));
        assertEq(id, 1);
        assertEq(nft.ownerOf(1), address(0xBEEF));
    }

    function test_RevertOnPause() public {
        nft.pause();
        vm.prank(address(0xBEEF));
        vm.expectRevert(BaseERC721.MintClosed.selector);
        nft.publicMint{ value: 0.01 ether }(address(0xBEEF));
    }

    receive() external payable {}
}
