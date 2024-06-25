# Simple Deposit and Withdrawal Smart Contract

## Description

This project contains a Solidity smart contract that implements a basic deposit and withdrawal system. It allows users to deposit funds into the contract and enables the owner to withdraw funds. The contract includes safeguards using `require()`, `assert()`, and `revert()` statements to ensure secure and correct operation.

---

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Code](#code)

---

## Installation

To interact with this smart contract, you need:

- A development environment with Solidity compiler (e.g., Remix, Hardhat, Truffle).
- Access to a blockchain network (e.g., Ethereum testnet or local blockchain).

1. Clone the repository:
    - git clone https://github.com/your-username/your-repository.git
    - cd your-repository
  
## Usage

### Deploying the Contract

Use your preferred Solidity development environment (e.g., Remix):

1. **Compile the contract (`Contract.sol`):**
   - Open Remix IDE.
   - Select `Contract.sol` file.
   - Compile the contract.

2. **Deploy the contract to your chosen blockchain network.**

### Interacting with the Contract

Once deployed, you can interact with the contract:

- **Deposit funds:** Use the `deposit` function to add funds to the contract.
- **Withdraw funds:** Use the `withdraw` function (accessible only by the owner) to retrieve funds.

---

## Examples

### Deploying the Contract (using Remix IDE)

1. **Compile and Deploy `Contract.sol`:**
   - Open Remix IDE.
   - Select `Contract.sol` file.
   - Compile and deploy.

### Interacting with the Contract (using Remix IDE)

- **Deposit Funds:**
  - **Amount:** 100 Wei
  - Execute `deposit(100)` with 100 Wei attached.

- **Withdraw Funds:**
  - **Amount:** 50 Wei
  - Execute `withdraw(50)` as the owner.


## Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Contract {
    address public owner;
    uint256 public balance;

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function deposit(uint256 amount) public payable {
        require(msg.value == amount, "Incorrect amount sent");
        balance += amount;
        assert(balance >= amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(balance >= amount, "Insufficient balance");
        balance -= amount;
        payable(owner).transfer(amount);
    }

    function resetBalance() view public onlyOwner {
        revert("Resetting balance is not allowed");
    }

    function dangerousFunction() public pure {
        revert("This function is dangerous and always reverts");
    }
}
