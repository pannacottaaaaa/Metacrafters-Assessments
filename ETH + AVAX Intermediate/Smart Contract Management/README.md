# Project Setup

This guide will help you set up and run the project locally.

## Prerequisites

- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [MetaMask Extension](https://metamask.io/)

## Installation and Setup

1. **Install Dependencies**

   Open the project directory in your terminal and run:
   ```sh
   npm install

## Setting Up Development Environment

### Step 1: Start the Hardhat Local Blockchain Node
Open Terminal 1 and run:
```bash
npx hardhat node
```

### Step 2: Deploy Smart Contracts to Local Network
Open Terminal 2 and run:
```bash
npx hardhat run --network localhost scripts/deploy.js
```

### Step 3: Launch the Front-end Application
Open Terminal 3 and run:
```bash
npm run dev
```

### MetaMask Configuration

#### Install MetaMask Extension
- Install the MetaMask extension in your web browser from [here](https://metamask.io/).

#### Add Local Network to MetaMask
1. Manually add a new network in MetaMask with the following details:
   - **Network Name:** (can be anything you like)
   - **RPC URL:** `http://127.0.0.1:8545/`
   - **Chain ID:** `31337`
   - **Currency Symbol:** ETH
2. Click Save and switch to your newly created network.

#### Import Account to MetaMask
1. Go back to the terminal where you started the Hardhat node (`npx hardhat node`).
2. Copy the private key of Account 0.
3. Import this account into MetaMask.

### Running the Project
After following the above steps, your local blockchain and front-end application should be up and running. You can now interact with the deployed smart contracts through the front-end interface.
