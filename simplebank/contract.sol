// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    // Mapping that keeps track of balances
    mapping(address => uint) public balances;

    // Event declarations for logging activities
    event DepositMade(address indexed accountAddress, uint amount);
    event WithdrawalMade(address indexed accountAddress, uint amount);

    // Contract balance
    uint public contractBalance;

    // Deposit Ether into the bank, increasing the balance
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");

        // Update account balance
        balances[msg.sender] += msg.value;
        emit DepositMade(msg.sender, msg.value);

        // Update contract balance
        contractBalance += msg.value;
    }
    // Withdraw Ether from the bank
    function withdraw(uint _amount) public {
        //require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(contractBalance >= _amount, "Insufficient contract balance");
        payable(msg.sender).transfer(_amount);

        // Update account balance
        balances[msg.sender] -= _amount;
        emit WithdrawalMade(msg.sender, _amount);

        // Update contract balance
        contractBalance -= _amount;
    }

    // Return the balance of the caller
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    // Return the balance of the contract
    function getContractBalance() public view returns (uint) {
        return contractBalance;
    }

    // Fallback function to receive Ether
    receive() external payable {
        // Update contract balance
        contractBalance += msg.value;
        emit DepositMade(msg.sender, msg.value);
    }
}
