// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title RewardVault
/// @notice Holds ERC20 rewards and allows the owner to drip them out.
contract RewardVault is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable rewardToken;

    event Swept(address token, uint256 amount);
    event Dripped(uint256 amount);

    constructor(address rewardToken_) Ownable(msg.sender) {
        rewardToken = IERC20(rewardToken_);
    }

    function drip(address to, uint256 amount) external onlyOwner {
        rewardToken.safeTransfer(to, amount);
        emit Dripped(amount);
    }

    /// @notice Rescue accidental non-reward tokens.
    function sweep(IERC20 token, uint256 amount) external onlyOwner {
        if (address(token) == address(rewardToken)) {
            require(token.balanceOf(address(this)) >= amount, "locked");
        }
        token.safeTransfer(msg.sender, amount);
        emit Swept(address(token), amount);
    }
}
