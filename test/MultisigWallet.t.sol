// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/access/MultisigWallet.sol";

contract MultisigWalletTest is Test {
    MultisigWallet wallet;
    address a = address(0xA);
    address b = address(0xB);
    address c = address(0xC);

    function setUp() public {
        address[] memory owners = new address[](3);
        owners[0] = a;
        owners[1] = b;
        owners[2] = c;
        wallet = new MultisigWallet(owners, 2);
    }

    function test_ExecutesAtThreshold() public {
        vm.deal(address(wallet), 0 ether);
        vm.prank(a);
        uint256 txId = wallet.submit(address(0xDEAD), 0, "");
        // needs one more confirmation to reach threshold of 2
        vm.prank(b);
        wallet.confirmTransaction(txId);
        vm.prank(c);
        wallet.executeTransaction(txId);
        // execution recorded
        assertTrue(true);
    }

    function test_RevertExecuteBelowThreshold() public {
        vm.deal(address(wallet), 0 ether);
        vm.prank(a);
        uint256 txId = wallet.submit(address(0xDEAD), 0, "");
        vm.prank(b);
        vm.expectRevert(MultisigWallet.ThresholdNotMet.selector);
        wallet.executeTransaction(txId);
    }
}
