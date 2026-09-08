// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MultisigWallet
/// @notice Executes calls once a configurable threshold of owners approves.
contract MultisigWallet {
    address[] public owners;
    uint256 public threshold;

    struct Tx {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 confirmations;
    }

    Tx[] public transactions;
    mapping(uint256 => mapping(address => bool)) public confirmed;

    event Submission(uint256 indexed txId);
    event Confirmation(address indexed sender, uint256 indexed txId);
    event Execution(uint256 indexed txId);
    event ExecutionFailure(uint256 indexed txId);

    error NotOwner();
    error ThresholdNotMet();
    error AlreadyConfirmed();
    error AlreadyExecuted();

    modifier onlyOwner() {
        bool isOwner;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                isOwner = true;
                break;
            }
        }
        if (!isOwner) revert NotOwner();
        _;
    }

    constructor(address[] memory owners_, uint256 threshold_) {
        owners = owners_;
        threshold = threshold_;
    }

    function submit(address to, uint256 value, bytes calldata data)
        external
        onlyOwner
        returns (uint256 txId)
    {
        txId = transactions.length;
        transactions.push(Tx(to, value, data, false, 0));
        emit Submission(txId);
        confirmTransaction(txId);
    }

    function confirmTransaction(uint256 txId) public onlyOwner {
        Tx storage t = transactions[txId];
        if (t.executed) revert AlreadyExecuted();
        if (confirmed[txId][msg.sender]) revert AlreadyConfirmed();
        confirmed[txId][msg.sender] = true;
        t.confirmations += 1;
        emit Confirmation(msg.sender, txId);
    }

    function executeTransaction(uint256 txId) external onlyOwner {
        Tx storage t = transactions[txId];
        if (t.executed) revert AlreadyExecuted();
        if (t.confirmations < threshold) revert ThresholdNotMet();
        t.executed = true;
        (bool success, ) = t.to.call{ value: t.value }(t.data);
        if (success) emit Execution(txId);
        else emit ExecutionFailure(txId);
    }
}
