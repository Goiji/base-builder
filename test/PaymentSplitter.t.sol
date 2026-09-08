// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PaymentSplitter.sol";

contract PaymentSplitterTest is Test {
    PaymentSplitter splitter;
    address payable A = payable(address(0xA));
    address payable B = payable(address(0xB));

    function setUp() public {
        address[] memory payees = new address[](2);
        payees[0] = A;
        payees[1] = B;
        uint256[] memory shares = new uint256[](2);
        shares[0] = 1;
        shares[1] = 3;
        splitter = new PaymentSplitter(payees, shares);
    }

    function test_SplitsByShares() public {
        vm.deal(address(splitter), 4 ether);
        splitter.release(A);
        assertEq(A.balance, 1 ether);
        splitter.release(B);
        assertEq(B.balance, 3 ether);
    }

    function test_PendingAccountsForReleased() public {
        vm.deal(address(splitter), 4 ether);
        splitter.release(A);
        assertEq(splitter.pending(A), 0);
        assertEq(splitter.pending(B), 3 ether);
    }
}
