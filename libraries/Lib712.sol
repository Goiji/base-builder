// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Lib712
/// @notice Builds EIP-712 type hashes from raw strings.
library Lib712 {
    function hashString(string memory value) internal pure returns (bytes32) {
        return keccak256(bytes(value));
    }

    function buildDomainSeparator(
        string memory name,
        string memory version,
        uint256 chainId,
        address verifyingContract
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                hashString(name),
                hashString(version),
                chainId,
                verifyingContract
            )
        );
    }
}
