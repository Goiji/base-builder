// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LibMath
/// @notice Minimal, checked math helpers used across the kit.
library LibMath {
    /// @notice Computes min of two values.
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /// @notice Computes max of two values.
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /// @notice Returns absolute difference between two values.
    function diff(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a - b : b - a;
    }
}
