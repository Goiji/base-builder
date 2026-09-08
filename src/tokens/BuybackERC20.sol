// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BaseERC20.sol";

/// @title BuybackERC20
/// @notice Capped ERC20 that burns a small share of every transfer.
contract BuybackERC20 is BaseERC20 {
    uint256 public burnBasisPoints;
    uint256 public constant MAX_BURN = 2000; // 20%

    error InvalidRatio();

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 maxSupply_,
        uint256 burnBasisPoints_
    ) BaseERC20(name_, symbol_, decimals_, maxSupply_) {
        if (burnBasisPoints_ > MAX_BURN) revert InvalidRatio();
        burnBasisPoints = burnBasisPoints_;
    }

    function setBurnBasisPoints(uint256 burnBasisPoints_) external onlyOwner {
        if (burnBasisPoints_ > MAX_BURN) revert InvalidRatio();
        burnBasisPoints = burnBasisPoints_;
    }

    function _update(address from, address to, uint256 value)
        internal
        override(BaseERC20)
    {
        super._update(from, to, value);
        // Burn a proportional share from the recipient for real transfers only.
        bool isTransfer = from != address(0) && to != address(0);
        if (isTransfer && burnBasisPoints > 0) {
            uint256 burned = (value * burnBasisPoints) / 10_000;
            if (burned > 0) super._update(to, address(0), burned);
        }
    }
}
