// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../libraries/LibAddress.sol";

contract FakeContract {
    constructor() payable {}
}

contract LibAddressTest is Test {
    function test_EOAIsNotContract() public view {
        assertFalse(LibAddress.isContract(address(this)));
    }

    function test_ContractDetected() public {
        FakeContract fc = new FakeContract();
        assertTrue(LibAddress.isContract(address(fc)));
    }
}
