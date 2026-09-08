// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Crowdfund
/// @notice Time-boxed ETH pool with goal tracking and a refund window.
contract Crowdfund is Ownable {
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalRaised;
    bool public closed;

    mapping(address => uint256) public contributions;

    event Contributed(address indexed backer, uint256 amount);
    event Refunded(address indexed backer, uint256 amount);
    event Withdrawn(uint256 amount);

    error NotStarted();
    error AlreadyClosed();
    error DeadlinePassed();

    constructor(uint256 goal_, uint256 duration_) Ownable(msg.sender) {
        goal = goal_;
        deadline = block.timestamp + duration_;
    }

    function contribute() external payable {
        if (block.timestamp > deadline) revert DeadlinePassed();
        if (closed) revert AlreadyClosed();
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
        emit Contributed(msg.sender, msg.value);
    }

    function close() external onlyOwner {
        if (block.timestamp < deadline && totalRaised < goal) revert NotStarted();
        closed = true;
    }

    function withdraw() external onlyOwner {
        require(closed, "not closed");
        uint256 amount = address(this).balance;
        totalRaised = 0;
        (bool ok, ) = msg.sender.call{ value: amount }("");
        require(ok, "failed");
        emit Withdrawn(amount);
    }

    function refund() external {
        require(block.timestamp > deadline && totalRaised < goal, "no refund");
        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        totalRaised -= amount;
        (bool ok, ) = msg.sender.call{ value: amount }("");
        require(ok, "failed");
        emit Refunded(msg.sender, amount);
    }
}
