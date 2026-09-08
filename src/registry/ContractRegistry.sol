// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

/// @title ContractRegistry
/// @notice Namespace-aware registry mapping string names to contract addresses.
contract ContractRegistry is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    mapping(string => address) public entries;

    event Registered(string indexed name, address indexed addr);
    event Unregistered(string indexed name);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    function register(string calldata name, address addr) external onlyRole(ADMIN_ROLE) {
        entries[name] = addr;
        emit Registered(name, addr);
    }

    function unregister(string calldata name) external onlyRole(ADMIN_ROLE) {
        delete entries[name];
        emit Unregistered(name);
    }

    function get(string calldata name) external view returns (address) {
        return entries[name];
    }
}
