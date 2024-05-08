// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SimpleBank contract allows depositing and withdrawing Ether and keeps track of individual and total balances.
contract SimpleBank {
    // Mapping that keeps track of balances for each address
    mapping(address => uint) public balances;

    // Event declarations for logging activities
    event DepositMade(address indexed accountAddress, uint amount); // Log when a deposit is made
    event WithdrawalMade(address indexed accountAddress, uint amount); // Log when a withdrawal is made

    // Total Ether balance stored in the contract
    uint public contractBalance;

    // Function to deposit Ether into the bank, increasing both the sender's balance and the contract's balance
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0"); // Check that the deposit is not zero

        // Update sender's balance in the mapping
        balances[msg.sender] += msg.value;
        emit DepositMade(msg.sender, msg.value); // Emit a log for the deposit

        // Update the total balance of the contract
        contractBalance += msg.value;
    }

    // Function to withdraw Ether from the bank
    function withdraw(uint _amount) public {
        require(contractBalance >= _amount, "Insufficient contract balance"); // Check if the contract has enough Ether
        require(balances[msg.sender] >= _amount, "Insufficient balance"); // Check if user has enough balance to withdraw

        payable(msg.sender).transfer(_amount); // Transfer Ether back to the sender

        // Update sender's balance in the mapping
        balances[msg.sender] -= _amount;
        emit WithdrawalMade(msg.sender, _amount); // Emit a log for the withdrawal

        // Update the total balance of the contract
        contractBalance -= _amount;
    }

    // View function to return the balance of the caller
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    // View function to return the total balance of the contract
    function getContractBalance() public view returns (uint) {
        return contractBalance;
    }

    // Fallback function to handle receiving Ether when the sender does not specify a function call
    receive() external payable {
        contractBalance += msg.value; // Update the total balance of the contract
        emit DepositMade(msg.sender, msg.value); // Emit a log for the deposit
    }
}
