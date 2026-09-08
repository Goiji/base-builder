// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Allowlist
/// @notice Off-chain-friendly allowlist storage with owner management.
contract Allowlist is Ownable {
    mapping(address => bool) public allowed;
    uint256 public totalAllowed;

    event Allowed(address indexed account, bool status);

    constructor() Ownable(msg.sender) {}

    function setAllowed(address account, bool status) external onlyOwner {
        if (allowed[account] != status) {
            allowed[account] = status;
            totalAllowed += status ? 1 : 0;
            if (!status && totalAllowed > 0) totalAllowed -= 1;
        }
        emit Allowed(account, status);
    }

    function setMany(address[] calldata accounts, bool status) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            setAllowed(accounts[i], status);
        }
    }

    function isAllowed(address account) external view returns (bool) {
        return allowed[account];
    }
}
