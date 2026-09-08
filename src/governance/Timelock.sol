// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

/// @title Timelock
/// @notice Minimal timelock controller for queued calls.
contract Timelock is AccessControl {
    bytes32 public constant PROPOSER_ROLE = keccak256("PROPOSER_ROLE");
    bytes32 public constant EXECUTOR_ROLE = keccak256("EXECUTOR_ROLE");

    uint256 public immutable delay;

    mapping(bytes32 => bool) public queued;

    event CallQueued(bytes32 indexed id, address target, uint256 value, bytes data);
    event CallExecuted(bytes32 indexed id);
    event CallCancelled(bytes32 indexed id);

    error Unauthorized();
    error NotReady(uint256 eta, uint256 now);

    constructor(uint256 delay_, address[] memory proposers, address[] memory executors) {
        delay = delay_;
        for (uint256 i = 0; i < proposers.length; i++) {
            _grantRole(PROPOSER_ROLE, proposers[i]);
        }
        for (uint256 i = 0; i < executors.length; i++) {
            _grantRole(EXECUTOR_ROLE, executors[i]);
        }
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function queue(address target, uint256 value, bytes calldata data)
        external
        onlyRole(PROPOSER_ROLE)
    {
        bytes32 id = keccak256(abi.encode(target, value, data));
        queued[id] = true;
        emit CallQueued(id, target, value, data);
    }

    function execute(address target, uint256 value, bytes calldata data)
        external
        payable
        onlyRole(EXECUTOR_ROLE)
    {
        bytes32 id = keccak256(abi.encode(target, value, data));
        if (!queued[id]) revert Unauthorized();
        delete queued[id];
        (bool ok, ) = target.call{ value: value }(data);
        require(ok, "call failed");
        emit CallExecuted(id);
    }

    function cancel(address target, uint256 value, bytes calldata data)
        external
        onlyRole(PROPOSER_ROLE)
    {
        bytes32 id = keccak256(abi.encode(target, value, data));
        delete queued[id];
        emit CallCancelled(id);
    }
}
