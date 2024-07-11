# Decentralized Crowdfunding Platform

## Description

This project contains a Solidity smart contract that implements a decentralized crowdfunding platform. It allows users to create crowdfunding campaigns, pledge funds to these campaigns, and withdraw funds based on the success of the campaign. The contract includes safeguards using `require()` statements to ensure secure and correct operation. Events are used to log significant actions such as campaign creation, pledging, and withdrawals.

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

1. **Compile the contract (`Crowdfunding.sol`):**
   - Open Remix IDE.
   - Select `Crowdfunding.sol` file.
   - Compile the contract.

2. **Deploy the contract to your chosen blockchain network.**

### Interacting with the Contract

Once deployed, you can interact with the contract:

- **Create Campaign:** Use the `createCampaign` function to create a new crowdfunding campaign.
- **Pledge:** Use the `pledge` function to support a campaign.
- **Withdraw:** Use the `withdraw` function to either claim the funds for a successful campaign or get back the pledged funds if the campaign fails.
- **Get Campaign:** Use the `getCampaign` function to retrieve details of a specific campaign.

---

## Examples

### Deploying the Contract (using Remix IDE)

1. **Compile and Deploy `Crowdfunding.sol`:**
   - Open Remix IDE.
   - Select `Crowdfunding.sol` file.
   - Compile and deploy.

### Interacting with the Contract (using Remix IDE)

- **Create Campaign:**
  - **Title:** "Innovative Project"
  - **Description:** "A project to innovate the world."
  - **Goal:** 100 ETH
  - **Duration:** 30 days
  - Execute `createCampaign("Innovative Project", "A project to innovate the world.", 100 ether, 30 days)`.

- **Pledge:**
  - **Campaign ID:** 1
  - **Amount:** 5 ETH
  - Execute `pledge(1)` with a value of 5 ETH.

- **Withdraw:**
  - **Campaign ID:** 1
  - Execute `withdraw(1)`.

- **Get Campaign:**
  - **Campaign ID:** 1
  - Execute `getCampaign(1)` to retrieve the details of campaign ID 1.

---

## Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint256 public campaignCount;

    struct Campaign {
        uint256 id;
        address payable creator;
        string title;
        string description;
        uint256 goal;
        uint256 pledged;
        uint256 deadline;
        bool exists;
        bool completed;
    }

    mapping(uint256 => Campaign) public campaigns;
    mapping(address => mapping(uint256 => uint256)) public pledges; // Tracks pledges of each address for each campaign

    event CampaignCreated(uint256 id, string title, uint256 goal, uint256 deadline);
    event Pledged(uint256 campaignId, address backer, uint256 amount);
    event Withdrawn(uint256 campaignId, address backer, uint256 amount);
    event CampaignCompleted(uint256 campaignId, address creator, uint256 amount);

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
        campaignCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier campaignExists(uint256 campaignId) {
        require(campaigns[campaignId].exists, "Campaign does not exist");
        _;
    }

    function createCampaign(
        string memory title,
        string memory description,
        uint256 goal,
        uint256 duration
    ) public {
        require(goal > 0, "Goal should be greater than zero");
        require(duration > 0, "Duration should be greater than zero");

        campaignCount++;
        uint256 deadline = block.timestamp + duration;

        campaigns[campaignCount] = Campaign(
            campaignCount,
            payable(msg.sender),
            title,
            description,
            goal,
            0,
            deadline,
            true,
            false
        );

        emit CampaignCreated(campaignCount, title, goal, deadline);
    }

    function pledge(uint256 campaignId) public payable campaignExists(campaignId) {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has ended");
        require(!campaign.completed, "Campaign is already completed");

        campaign.pledged += msg.value;
        pledges[msg.sender][campaignId] += msg.value;

        emit Pledged(campaignId, msg.sender, msg.value);
    }

    function withdraw(uint256 campaignId) public campaignExists(campaignId) {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp >= campaign.deadline, "Campaign is still ongoing");
        require(!campaign.completed, "Campaign is already completed");

        if (campaign.pledged >= campaign.goal) {
            campaign.completed = true;
            campaign.creator.transfer(campaign.pledged);

            emit CampaignCompleted(campaignId, campaign.creator, campaign.pledged);
        } else {
            uint256 amount = pledges[msg.sender][campaignId];
            require(amount > 0, "No funds to withdraw");

            pledges[msg.sender][campaignId] = 0;
            payable(msg.sender).transfer(amount);

            emit Withdrawn(campaignId, msg.sender, amount);
        }
    }

    function getCampaign(uint256 campaignId) public view returns (
        string memory title,
        string memory description,
        uint256 goal,
        uint256 pledged,
        uint256 deadline,
        bool completed
    ) {
        require(campaigns[campaignId].exists, "Campaign does not exist");

        Campaign storage campaign = campaigns[campaignId];
        return (
            campaign.title,
            campaign.description,
            campaign.goal,
            campaign.pledged,
            campaign.deadline,
            campaign.completed
        );
    }
}
```
