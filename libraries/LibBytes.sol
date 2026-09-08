// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LibBytes
/// @notice Byte-array helpers for calldata processing.
library LibBytes {
    /// @notice Trims leading zero bytes from a hex-like representation array.
    function trim(bytes memory data) internal pure returns (bytes memory) {
        uint256 start;
        for (; start < data.length; start++) {
            if (data[start] != 0) break;
        }
        bytes memory out = new bytes(data.length - start);
        for (uint256 i = 0; i < out.length; i++) {
            out[i] = data[start + i];
        }
        return out;
    }
}
