// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title WhitelistSale
/// @notice Shared merkle-whitelist gating that other contracts can inherit.
contract WhitelistSale is Ownable {
    bytes32 public whitelistRoot;
    mapping(address => uint256) public claimed;

    error NotWhitelisted();
    error ExceededAllowance(uint256 allowed);

    constructor() Ownable(msg.sender) {}

    modifier onlyWhitelisted(uint256 allowed, bytes32[] calldata proof) {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, allowed));
        if (!MerkleProof.verify(proof, whitelistRoot, leaf)) revert NotWhitelisted();
        if (claimed[msg.sender] >= allowed) revert ExceededAllowance(allowed);
        _;
    }

    function setWhitelistRoot(bytes32 root) external onlyOwner {
        whitelistRoot = root;
    }
}
