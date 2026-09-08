// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title PaymentSplitter
/// @notice Splits native ETH between payees by fixed shares.
contract PaymentSplitter {
    address[] public payees;
    uint256[] public shares;
    uint256 public totalShares;

    receive() external payable {}

    constructor(address[] memory payees_, uint256[] memory shares_) {
        require(payees_.length == shares_.length, "length mismatch");
        for (uint256 i = 0; i < payees_.length; i++) {
            payees.push(payees_[i]);
            shares.push(shares_[i]);
            totalShares += shares_[i];
        }
    }

    function release(address payable payee) external {
        (bool found, uint256 due) = _due(payee);
        require(found, "not a payee");
        (bool ok, ) = payee.call{ value: due }("");
        require(ok, "transfer failed");
    }

    function _due(address payee) private view returns (bool, uint256) {
        for (uint256 i = 0; i < payees.length; i++) {
            if (payees[i] == payee) {
                uint256 owed = (address(this).balance * shares[i]) / totalShares;
                return (true, owed);
            }
        }
        return (false, 0);
    }
}
