// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LibAddress
/// @notice Helpers to distinguish EOAs from contracts on-chain.
library LibAddress {
    error AddressEmptyCode(address account);
    error AddressHasCode(address account);

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function _revertIfContract(address account) internal view {
        if (isContract(account)) revert AddressHasCode(account);
    }

    function _revertIfEOA(address account) internal view {
        if (!isContract(account)) revert AddressEmptyCode(account);
    }
}
