// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Contract {
    address public owner;
    uint256 public balance;

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
    }

    modifier onlyOwner() {
        // Using require to ensure only the owner can execute certain functions
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function deposit(uint256 amount) public payable {
        // Using require to check that the amount sent is correct
        require(msg.value == amount, "Incorrect amount sent");

        // Update balance
        balance += amount;

        // Using assert to verify the balance update
        assert(balance >= amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        // Using require to check that the contract has enough balance
        require(balance >= amount, "Insufficient balance");

        // Update balance before transferring to prevent reentrancy attacks
        balance -= amount;

        // Transfer the amount to the owner
        payable(owner).transfer(amount);
    }

    function resetBalance() view public onlyOwner {
        // Using revert to undo state changes and provide a custom error message
        revert("Resetting balance is not allowed");
    }

    function dangerousFunction() public pure {
        // This function always reverts with a custom error message
        revert("This function is dangerous and always reverts");
    }
}
