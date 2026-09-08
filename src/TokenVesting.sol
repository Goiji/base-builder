// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title TokenVesting
/// @notice Distributes a locked ERC20 over a linear cliff + vesting schedule.
contract TokenVesting is Ownable, ReentrancyGuard {
    IERC20 public immutable token;
    address public immutable beneficiary;

    uint256 public immutable startTime;
    uint256 public immutable cliffDuration;
    uint256 public immutable totalDuration;

    uint256 public released;

    event TokensReleased(address beneficiary, uint256 amount);

    error NothingToRelease();
    error InsufficientBalance(uint256 available);

    constructor(
        address token_,
        address beneficiary_,
        uint256 startTime_,
        uint256 cliffDuration_,
        uint256 totalDuration_
    ) Ownable(msg.sender) {
        token = IERC20(token_);
        beneficiary = beneficiary_;
        startTime = startTime_;
        cliffDuration = cliffDuration_;
        totalDuration = totalDuration_;
    }

    function vestedAmount(uint256 totalAllocation) public view returns (uint256) {
        if (block.timestamp < startTime + cliffDuration) return 0;
        if (block.timestamp >= startTime + totalDuration) return totalAllocation;
        return (totalAllocation * (block.timestamp - startTime)) / totalDuration;
    }

    function releasableAmount() public view returns (uint256) {
        uint256 balance = token.balanceOf(address(this));
        uint256 vested = vestedAmount(balance + released);
        uint256 vestedNow = vested > released ? vested - released : 0;
        return vestedNow > balance ? balance : vestedNow;
    }

    function release() external nonReentrant {
        uint256 amount = releasableAmount();
        if (amount == 0) revert NothingToRelease();
        released += amount;
        if (token.balanceOf(address(this)) < amount) revert InsufficientBalance(amount);
        token.transfer(beneficiary, amount);
        emit TokensReleased(beneficiary, amount);
    }
}
