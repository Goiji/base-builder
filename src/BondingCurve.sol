// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BondingCurve
/// @notice A linear bonding-curve constant-sum market.
/// @dev Reserve currency is the base EVM asset (ETH).
contract BondingCurve {
    uint256 public immutable slope;   // wei per unit of supply
    uint256 public immutable baseFee; // fixed starting fee per unit

    uint256 public totalSupply;

    error InsufficientReserve(uint256 required, uint256 sent);
    error NoSupply();

    constructor(uint256 slope_, uint256 baseFee_) {
        slope = slope_;
        baseFee = baseFee_;
    }

    /// @notice Price for buying `amount` tokens at current supply.
    function buyCost(uint256 amount) public view returns (uint256) {
        uint256 s0 = totalSupply;
        // integral of (baseFee + slope*s) from s0 to s0+amount
        return baseFee * amount + (slope * (2 * s0 * amount + amount * amount)) / 2;
    }

    /// @notice Ether returned when selling `amount` at current supply.
    function sellProceeds(uint256 amount) public view returns (uint256) {
        if (amount > totalSupply) revert NoSupply();
        uint256 s1 = totalSupply - amount;
        // integral from s1 to s1+amount
        return baseFee * amount + (slope * (2 * s1 * amount + amount * amount)) / 2;
    }

    function buy(uint256 amount) external payable {
        uint256 cost = buyCost(amount);
        if (msg.value < cost) revert InsufficientReserve(cost, msg.value);
        totalSupply += amount;
        uint256 refund = msg.value - cost;
        if (refund > 0) {
            (bool ok, ) = msg.sender.call{ value: refund }("");
            require(ok, "refund failed");
        }
    }

    function sell(uint256 amount) external {
        uint256 proceeds = sellProceeds(amount);
        totalSupply -= amount;
        (bool ok, ) = msg.sender.call{ value: proceeds }("");
        require(ok, "payout failed");
    }
}
