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

## Frontend Implementation

### HTML File

Create an `index.html` file with the following content:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Game</title>
</head>
<body>
    <h1>Simple Game</h1>
    <button id="connectButton">Connect to MetaMask</button>
    <div id="gameSection" style="display: none;">
        <h2>Play Game</h2>
        <input type="number" id="guessInput" placeholder="Enter your guess (1-10)">
        <button id="playButton">Play Game</button>
        <h2>Claim Tokens</h2>
        <button id="claimButton">Claim Tokens</button>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/web3/dist/web3.min.js"></script>
    <script src="app.js"></script>
</body>
</html>
```

### JavaScript File

Create an `app.js` file with the following content. Make sure to replace the placeholders with your actual contract address and ABI:

```javascript
let web3;
let contract;
const contractAddress = 'YOUR_CONTRACT_ADDRESS'; // Replace with your deployed contract address
const contractABI = [ /* ABI array here */ ]; // Replace with your contract's ABI

window.addEventListener('load', async () => {
    if (typeof window.ethereum !== 'undefined') {
        web3 = new Web3(window.ethereum);
    } else {
        alert('MetaMask is not installed. Please install it to use this app.');
    }
});

document.getElementById('connectButton').addEventListener('click', async () => {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
    document.getElementById('gameSection').style.display = 'block';
    contract = new web3.eth.Contract(contractABI, contractAddress);
});

document.getElementById('playButton').addEventListener('click', async () => {
    const accounts = await web3.eth.getAccounts();
    const guess = document.getElementById('guessInput').value;
    const gameCost = await contract.methods.gameCost().call();

    await contract.methods.playGame(guess).send({ from: accounts[0], value: gameCost });
});

document.getElementById('claimButton').addEventListener('click', async () => {
    const accounts = await web3.eth.getAccounts();
    await contract.methods.claimTokens().send({ from: accounts[0] });
});
```

### Configuration for `lite-server`

Create a `bs-config.json` file in the project directory:

```json
{
  "server": {
    "baseDir": ["./"],
    "routes": {
      "/node_modules": "node_modules"
    }
  }
}
```

### Update `package.json` Scripts

Update the `scripts` section of your `package.json` to include a start script for `lite-server`:

```json
"scripts": {
  "start": "lite-server"
}
```

### Start the Frontend

Now you can start the frontend server:

```bash
npm start
```

### Access the Application

Open your browser and navigate to `http://localhost:3000`. You should see the SimpleGame interface and be able to connect to MetaMask and interact with your smart contract.

Follow the instructions carefully to ensure everything is set up correctly. Enjoy playing the game and claiming your rewards!
