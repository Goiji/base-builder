// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PaymentSplitter.sol";

contract PaymentSplitterMoreTest is Test {
    PaymentSplitter splitter;
    address payable A = payable(address(0xA));

    function setUp() public {
        address[] memory payees = new address[](1);
        payees[0] = A;
        uint256[] memory shares = new uint256[](1);
        shares[0] = 1;
        splitter = new PaymentSplitter(payees, shares);
    }

    function test_TracksReleasedCumulatively() public {
        vm.deal(address(splitter), 3 ether);
        splitter.release(A);
        assertEq(splitter.released(A), 3 ether);
        vm.deal(address(splitter), 2 ether);
        splitter.release(A);
        assertEq(splitter.released(A), 5 ether);
        assertEq(A.balance, 5 ether);
    }
}
