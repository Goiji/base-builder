// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/access/MultisigWallet.sol";

contract MultisigMoreTest is Test {
    MultisigWallet wallet;
    address owner = address(0xAA);
    address stranger = address(0xFF);

    function setUp() public {
        address[] memory owners = new address[](1);
        owners[0] = owner;
        wallet = new MultisigWallet(owners, 1);
    }

    function test_NonOwnerCannotSubmit() public {
        vm.prank(stranger);
        vm.expectRevert(MultisigWallet.NotOwner.selector);
        wallet.submit(address(0xDEAD), 0, "");
    }
}
