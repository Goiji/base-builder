// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/BaseERC20.sol";
import "../src/MerkleAirdrop.sol";

contract MerkleAirdropTest is Test {
    BaseERC20 token;
    MerkleAirdrop airdrop;
    bytes32 root;

    // two leaves for users 0xA and 0xB
    bytes32 constant L0 = 0x0000000000000000000000000000000000000000000000000000000000000000;
    bytes32 constant L1 = keccak256(abi.encode(address(0xB), 2e18));

    function setUp() public {
        token = new BaseERC20("Drop", "DROP", 18, 1e24);
        // build root over leaves for 0xA=1e18 and 0xB=2e18
        bytes32 leafA = keccak256(abi.encode(address(0xA), 1e18));
        bytes32 leafB = L1;
        root = keccak256(abi.encodePacked(leafA < leafB ? leafA : leafB, leafA < leafB ? leafB : leafA));
        airdrop = new MerkleAirdrop(address(token), root, block.timestamp + 30 days);
        token.mint(address(airdrop), 10e18);
    }

    function _proofB() internal pure returns (bytes32[] memory p) {
        p = new bytes32[](1);
        bytes32 leafA = keccak256(abi.encode(address(0xA), 1e18));
        p[0] = leafA;
    }

    function test_ClaimSuccess() public {
        vm.prank(address(0xB));
        airdrop.claim(2e18, _proofB());
        assertEq(token.balanceOf(address(0xB)), 2e18);
    }

    function test_RevertDoubleClaim() public {
        vm.startPrank(address(0xB));
        airdrop.claim(2e18, _proofB());
        vm.expectRevert(MerkleAirdrop.AlreadyClaimed.selector);
        airdrop.claim(2e18, _proofB());
        vm.stopPrank();
    }
}
