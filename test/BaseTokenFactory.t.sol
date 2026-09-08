// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/factory/BaseTokenFactory.sol";
import "../src/tokens/BaseERC20.sol";

contract BaseTokenFactoryTest is Test {
    BaseTokenFactory factory;

    function setUp() public {
        factory = new BaseTokenFactory();
    }

    function test_DeterministicDeploy() public {
        bytes32 salt = bytes32(uint256(7));
        address predicted = factory.predictERC20(address(this), salt);
        address deployed = factory.deployERC20("A", "A", 18, 1e21, salt);
        assertEq(deployed, predicted);
        BaseERC20 t = BaseERC20(deployed);
        assertEq(t.name(), "A");
    }

    function test_RegistryIsPopulated() public {
        bytes32 salt = keccak256("salt");
        address deployed = factory.deployERC20("B", "B", 6, 1e21, salt);
        bytes32 addrSalt = keccak256(abi.encode(address(this), salt));
        assertEq(factory.deployments(addrSalt), deployed);
    }
}
