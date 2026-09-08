// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title PaymentSplitter
/// @notice Splits native ETH between payees by fixed, immutable shares.
contract PaymentSplitter {
    address[] public payees;
    uint256[] public shares;
    uint256 public totalShares;
    mapping(address => uint256) public released;

    event PayeeAdded(address payee, uint256 shares);
    event PaymentReleased(address payee, uint256 amount);

    receive() external payable {}

    constructor(address[] memory payees_, uint256[] memory shares_) {
        require(payees_.length == shares_.length, "length mismatch");
        for (uint256 i = 0; i < payees_.length; i++) {
            payees.push(payees_[i]);
            shares.push(shares_[i]);
            totalShares += shares_[i];
            emit PayeeAdded(payees_[i], shares_[i]);
        }
    }

    function pending(address payee) public view returns (uint256) {
        uint256 owed = (address(this).balance * _share(payee)) / totalShares;
        return owed > released[payee] ? owed - released[payee] : 0;
    }

    function release(address payable payee) external {
        uint256 amount = pending(payee);
        require(amount > 0, "nothing to release");
        released[payee] += amount;
        (bool ok, ) = payee.call{ value: amount }("");
        require(ok, "transfer failed");
        emit PaymentReleased(payee, amount);
    }

    function _share(address payee) private view returns (uint256) {
        for (uint256 i = 0; i < payees.length; i++) {
            if (payees[i] == payee) return shares[i];
        }
        revert("not a payee");
    }
}
