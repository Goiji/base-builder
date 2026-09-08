// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "./BaseERC20.sol";

/// @title PermitERC20
/// @notice Capped, pausable ERC20 with ERC20Permit gasless approvals.
contract PermitERC20 is BaseERC20, ERC20Permit {
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 maxSupply_
    ) BaseERC20(name_, symbol_, decimals_, maxSupply_)
      ERC20Permit(name_) {}

    function _update(address from, address to, uint256 value)
        internal
        override(BaseERC20)
    {
        super._update(from, to, value);
    }
}
