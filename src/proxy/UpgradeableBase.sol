// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title UpgradeableBase
/// @notice Initializable + ownable base intended for ERC1967 proxies.
abstract contract UpgradeableBase is Initializable, Ownable {
    uint256 public version;

    error AlreadyInitialized();

    // solhint-disable-next-line func-name-mixedcase
    function __UpgradeableBase_init(uint256 version_) internal onlyInitializing {
        version = version_;
        _transferOwnership(msg.sender);
    }
}
