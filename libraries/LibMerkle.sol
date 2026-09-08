// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LibMerkle
/// @notice Convenience wrapper around OpenZeppelin's MerkleProof.
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

library LibMerkle {
    function isClaim(
        bytes32 root,
        bytes32[] memory proof,
        bytes32 leaf
    ) internal pure returns (bool) {
        return MerkleProof.verify(proof, root, leaf);
    }
}
