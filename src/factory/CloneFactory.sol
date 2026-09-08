// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title CloneFactory
/// @notice Deploys cheap EIP-1167 clones of an approved implementation.
contract CloneFactory is Ownable {
    address public implementation;
    address[] public clones;

    event CloneDeployed(address indexed clone);
    event ImplementationChanged(address indexed impl);

    constructor() Ownable(msg.sender) {}

    function setImplementation(address impl) external onlyOwner {
        implementation = impl;
        emit ImplementationChanged(impl);
    }

    function deployClone(bytes32 salt) external returns (address clone) {
        clone = Clones.cloneDeterministic(implementation, salt);
        clones.push(clone);
        emit CloneDeployed(clone);
    }

    function cloneCount() external view returns (uint256) {
        return clones.length;
    }
}
