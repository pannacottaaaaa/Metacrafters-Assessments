# SimpleGame Smart Contract Project

This guide will help you set up and run the SimpleGame project locally.

## Prerequisites

- Node.js
- npm
- Visual Studio Code
- MetaMask Extension

## Installation and Setup

### Install Dependencies

Open the project directory in your terminal and run:

```bash
npm install
```

### Setting Up Development Environment

#### Step 1: Start the Hardhat Local Blockchain Node

Open Terminal 1 and run:

```bash
npx hardhat node
```

#### Step 2: Deploy Smart Contracts to Local Network

Open Terminal 2 and run:

```bash
npx hardhat run --network localhost scripts/deploy.js
```

#### Step 3: Launch the Front-end Application

Open Terminal 3 and run:

```bash
npm run dev
```

### MetaMask Configuration

#### Install MetaMask Extension

Install the MetaMask extension in your web browser from [here](https://metamask.io/).

#### Add Local Network to MetaMask

Manually add a new network in MetaMask with the following details:

- **Network Name**: (can be anything you like)
- **RPC URL**: http://127.0.0.1:8545/
- **Chain ID**: 31337
- **Currency Symbol**: ETH

Click Save and switch to your newly created network.

#### Import Account to MetaMask

Go back to the terminal where you started the Hardhat node (`npx hardhat node`).

Copy the private key of Account 0.

Import this account into MetaMask.

### Running the Project

After following the above steps, your local blockchain and front-end application should be up and running. You can now interact with the deployed smart contracts through the front-end interface.

## Interacting with the SimpleGame Smart Contract

1. **Playing the Game**:
    - Enter a guess number between 1 and 10.
    - Send the game cost (Ether) to play.
    - If you guess correctly, you win double the amount you bet in tokens.

2. **Claiming Tokens**:
    - If you have won tokens, you can claim them.
    - The claimed tokens will be transferred to your MetaMask account.

3. **Adding Tokens (Owner only)**:
    - The owner can add more tokens to the contract for rewards.

## Smart Contract Details

- **Owner**: The address that deployed the contract and can add tokens.
- **Total Tokens**: The total number of tokens available in the contract for rewards.
- **Game Cost**: The cost in Ether to play the game.

## Events

- **GamePlayed**: Emitted when a game is played.
- **TokensClaimed**: Emitted when tokens are claimed.

Follow the instructions carefully to ensure everything is set up correctly. Enjoy playing the game and claiming your rewards!
