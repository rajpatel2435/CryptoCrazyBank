// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Arrays.sol";

contract TransactionContract {

    using Arrays for Transaction[];

    struct Transaction {
        uint256 id;
        address sender;
        address recipient;
        uint256 amount;
        uint256 timestamp;
        string description;
    }

    // mapping to store transactions
    mapping(uint256 => Transaction) public transactions;

    // mapping to store user transactions
    mapping(address => Transaction[]) public userTransactions;

    // event to emit transaction details
    event TransferTokens(address indexed sender, address indexed recipient, uint256 amount, string description);

    // function to transfer tokens
    function transferTokens(address _recipient, uint256 _amount, string memory _description) public {
        // Validate input data
        require(_amount > 0, "Amount must be greater than 0");
        require(_recipient != address(0), "Recipient cannot be zero address");

        // Get current block timestamp
        uint256 timestamp = block.timestamp;

        // Generate unique transaction ID
        uint256 transactionId = uint256(keccak256(abi.encodePacked(_recipient, _amount, _description, timestamp)));

        // Create transaction struct
        Transaction memory transaction = Transaction({
            id: transactionId,
            sender: msg.sender,
            recipient: _recipient,
            amount: _amount,
            timestamp: timestamp,
            description: _description
        });

        // Store transaction struct in mapping
        transactions[transactionId] = transaction;

        // Add transaction to user's transaction list

        userTransactions[msg.sender].push(transaction);
        userTransactions[_recipient].push(transaction);


        // Emit event to notify about the transfer
        emit TransferTokens(msg.sender, _recipient, _amount, _description);
    }

    // function to get user transactions
    function getUserTransactions(address _user) public view returns (Transaction[] memory) {
        // Get user transactions from mapping
        Transaction[] memory userTransactionsArray = userTransactions[_user];

        return userTransactionsArray;
    }

    function transferTokenOwnership(address _newOwner, uint256 _tokenId) public view {
        Transaction memory transaction = transactions[_tokenId];
        require(msg.sender == transaction.sender, "Only the sender can transfer the token");
        require(transaction.recipient == address(0), "Token has already been transferred");
        transaction.recipient = _newOwner;
    }
}