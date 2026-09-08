// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @title MerkleAirdrop
/// @notice Gas-efficient ERC20 airdrop verified against a merkle root.
contract MerkleAirdrop is Ownable, ReentrancyGuard {
    IERC20 public immutable token;
    bytes32 public merkleRoot;
    uint256 public immutable endTime;

    mapping(address => bool) public claimed;

    event Claimed(address indexed claimant, uint256 amount);
    event RootUpdated(bytes32 root);

    error AlreadyClaimed();
    error AirdropEnded();
    error InvalidProof();
    error RootEmpty();

    constructor(address token_, bytes32 merkleRoot_, uint256 endTime_) Ownable(msg.sender) {
        token = IERC20(token_);
        merkleRoot = merkleRoot_;
        endTime = endTime_;
    }

    function claim(uint256 amount, bytes32[] calldata proof) external nonReentrant {
        if (block.timestamp > endTime) revert AirdropEnded();
        if (claimed[msg.sender]) revert AlreadyClaimed();
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
        if (!MerkleProof.verify(proof, merkleRoot, leaf)) revert InvalidProof();
        claimed[msg.sender] = true;
        token.transfer(msg.sender, amount);
        emit Claimed(msg.sender, amount);
    }

    function setRoot(bytes32 newRoot) external onlyOwner {
        if (newRoot == bytes32(0)) revert RootEmpty();
        merkleRoot = newRoot;
        emit RootUpdated(newRoot);
    }
}
