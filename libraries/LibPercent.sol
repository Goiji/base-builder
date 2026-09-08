// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LibPercent
/// @notice Basis-point based proportional math with safe rounding.
library LibPercent {
    uint256 internal constant BASIS_POINTS = 10_000;

    /// @notice Returns amount * bp / 10000 rounding down.
    function mulDivDown(uint256 amount, uint256 bp) internal pure returns (uint256) {
        return (amount * bp) / BASIS_POINTS;
    }

    /// @notice Returns amount * bp / 10000 rounding up.
    function mulDivUp(uint256 amount, uint256 bp) internal pure returns (uint256) {
        return (amount * bp + BASIS_POINTS - 1) / BASIS_POINTS;
    }
}
