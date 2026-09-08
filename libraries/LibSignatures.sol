// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/// @title LibSignatures
/// @notice Thin wrapper that documents the expected recovery path.
library LibSignatures {
    /// @notice Recovers the signer of `digest` given a raw signature.
    function recover(bytes32 digest, bytes memory signature) internal pure returns (address) {
        return ECDSA.recover(digest, signature);
    }
}
