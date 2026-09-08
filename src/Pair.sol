// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Pair
/// @notice Constant-product automated market maker over two base assets.
/// @dev Intentionally minimal; reserved for a deeper AMM in a future release.
contract Pair {
    address public immutable tokenA;
    address public immutable tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    constructor(address tokenA_, address tokenB_) {
        tokenA = tokenA_;
        tokenB = tokenB_;
    }

    function k() public view returns (uint256) {
        return reserveA * reserveB;
    }

    function addLiquidity(uint256 aAmount, uint256 bAmount) external returns (uint256) {
        reserveA += aAmount;
        reserveB += bAmount;
        return k();
    }
}
