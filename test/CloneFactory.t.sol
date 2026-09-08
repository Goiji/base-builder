// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/factory/CloneFactory.sol";
import "../src/tokens/BaseERC20.sol";

contract CloneFactoryTest is Test {
    CloneFactory factory;
    BaseERC20 impl;

    function setUp() public {
        impl = new BaseERC20("Impl", "I", 18, 1e24);
        factory = new CloneFactory();
        factory.setImplementation(address(impl));
    }

    function test_DeploysClones() public {
        address c1 = factory.deployClone(bytes32(uint256(1)));
        address c2 = factory.deployClone(bytes32(uint256(1)));
        assertEq(c1, c2, "deterministic");
        assertEq(factory.cloneCount(), 2);
    }
}
