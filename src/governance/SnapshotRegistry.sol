// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title SnapshotRegistry
/// @notice Records a snapshot id at a block number for off-chain tallying.
contract SnapshotRegistry is Ownable {
    struct Snapshot {
        uint256 blockNumber;
        string uri;
    }

    uint256 public nextSnapshotId;
    mapping(uint256 => Snapshot) public snapshots;

    event SnapshotCreated(uint256 indexed id, uint256 blockNumber, string uri);

    constructor() Ownable(msg.sender) {}

    function create(string calldata uri) external onlyOwner returns (uint256 id) {
        id = nextSnapshotId++;
        snapshots[id] = Snapshot(block.number, uri);
        emit SnapshotCreated(id, block.number, uri);
    }

    function snapshotBlock(uint256 id) external view returns (uint256) {
        return snapshots[id].blockNumber;
    }
}
