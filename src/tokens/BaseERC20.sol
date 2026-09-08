// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title BaseERC20
/// @notice Mintable, burnable ERC20 with owner-managed pausable minting.
contract BaseERC20 is ERC20, Ownable {
    uint8 private _decimals;

    error AmountZero();

    /// @param name_ Token name.
    /// @param symbol_ Token symbol.
    /// @param decimals_ Number of decimals (fixed at deployment).
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        _decimals = decimals_;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    /// @notice Mints tokens to `to`.
    function mint(address to, uint256 amount) external onlyOwner {
        if (amount == 0) revert AmountZero();
        _mint(to, amount);
    }

    /// @notice Burns tokens from `from`.
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
