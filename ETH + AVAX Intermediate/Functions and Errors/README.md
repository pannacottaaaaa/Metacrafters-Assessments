# Simple Voting System Smart Contract

## Description

This project contains a Solidity smart contract that implements a basic voting system. It allows the contract owner to create proposals and enables users to vote on these proposals. The contract includes safeguards using `require()` statements to ensure secure and correct operation. Events are used to log significant actions such as proposal creation and voting.

---

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Code](#code)

---

## Installation

To interact with this smart contract, you need:

- A development environment with a Solidity compiler (e.g., Remix, Hardhat, Truffle).
- Access to a blockchain network (e.g., Ethereum testnet or local blockchain).

1. Clone the repository:
    ```sh
    git clone https://github.com/your-username/your-repository.git
    cd your-repository
    ```

## Usage

### Deploying the Contract

Use your preferred Solidity development environment (e.g., Remix):

1. **Compile the contract (`VotingSystem.sol`):**
   - Open Remix IDE.
   - Select `VotingSystem.sol` file.
   - Compile the contract.

2. **Deploy the contract to your chosen blockchain network.**

### Interacting with the Contract

Once deployed, you can interact with the contract:

- **Create Proposal:** Use the `createProposal` function to create a new proposal (accessible only by the owner).
- **Vote:** Use the `vote` function to cast a vote on a proposal.
- **Get Proposal:** Use the `getProposal` function to retrieve details of a specific proposal.

---

## Examples

### Deploying the Contract (using Remix IDE)

1. **Compile and Deploy `VotingSystem.sol`:**
   - Open Remix IDE.
   - Select `VotingSystem.sol` file.
   - Compile and deploy.

### Interacting with the Contract (using Remix IDE)

- **Create Proposal:**
  - **Description:** "New Proposal"
  - Execute `createProposal("New Proposal")` as the owner.

- **Vote:**
  - **Proposal ID:** 1
  - Execute `vote(1)` to vote on proposal ID 1.

- **Get Proposal:**
  - **Proposal ID:** 1
  - Execute `getProposal(1)` to retrieve the details of proposal ID 1.

---

## Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public owner;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string description;
        uint256 voteCount;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public votes; // Tracks if an address has voted on a proposal

    event ProposalCreated(uint256 id, string description);
    event Voted(uint256 proposalId, address voter);

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
        proposalCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function createProposal(string memory description) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, description, 0, true);

        emit ProposalCreated(proposalCount, description);
    }

    function vote(uint256 proposalId) public {
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(!votes[msg.sender][proposalId], "You have already voted on this proposal");

        proposals[proposalId].voteCount++;
        votes[msg.sender][proposalId] = true;

        emit Voted(proposalId, msg.sender);
    }

    function getProposal(uint256 proposalId) public view returns (string memory description, uint256 voteCount) {
        require(proposals[proposalId].exists, "Proposal does not exist");
        return (proposals[proposalId].description, proposals[proposalId].voteCount);
    }
}
