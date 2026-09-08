// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

abstract contract TestHelpers is Test {
    function randAddress(uint256 seed) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(seed)))));
    }

    function mkUsers(uint256 n) internal returns (address[] memory users) {
        users = new address[](n);
        for (uint256 i = 0; i < n; i++) {
            address u = randAddress(i + 1);
            vm.deal(u, 100 ether);
            users[i] = u;
        }
    }
}
