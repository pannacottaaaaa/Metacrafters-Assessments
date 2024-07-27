# Decentralized Savings and Investment Club Project

This guide will help you set up and run the Decentralized Savings and Investment Club project locally.

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

## Interacting with the DSIC Smart Contract

1. **Deposit Funds**:
    - Enter the amount you want to deposit and click "Deposit."
    - Your contribution will be recorded, and the balance will be updated.

2. **Withdraw Funds**:
    - Enter the amount you want to withdraw and click "Withdraw."
    - The funds will be transferred to your MetaMask account, and your contribution will be updated.

3. **Claim Returns**:
    - Click "Claim Returns" to receive any available returns based on your contributions.

## Smart Contract Details

### DSIC.sol

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract DSIC {
    address payable public owner;
    uint256 public balance;
    mapping(address => uint256) public contributions;
    mapping(address => uint256) public userReturns;

    address[] private users; // To keep track of users who have made contributions

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns(uint256){
        return balance;
    }

    function getUserContribution(address user) public view returns(uint256) {
        return contributions[user];
    }

    function getUserReturns(address user) public view returns(uint256) {
        return userReturns[user];
    }

    function deposit() public payable {
        uint _previousBalance = balance;

        // Perform transaction
        balance += msg.value;
        if (contributions[msg.sender] == 0) {
            users.push(msg.sender); // Add new user to the list
        }
        contributions[msg.sender] += msg.value;

        // Assert transaction completed successfully
        assert(balance == _previousBalance + msg.value);

        // Emit the event
        emit Deposit(msg.sender, msg.value);
    }

    // Custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(contributions[msg.sender] >= _withdrawAmount, "Insufficient contribution");

        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // Withdraw the given amount
        balance -= _withdrawAmount;
        contributions[msg.sender] -= _withdrawAmount;

        payable(msg.sender).transfer(_withdrawAmount);

        // Assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // Emit the event
        emit Withdraw(msg.sender, _withdrawAmount);
    }

    function distributeReturns(uint256 totalReturns) public {
        require(msg.sender == owner, "Only the owner can distribute returns");

        for (uint i = 0; i < users.length; i++) {
            address user = users[i];
            userReturns[user] += (contributions[user] * totalReturns) / balance;
        }
    }

    function claimReturns() public {
        uint256 userReturn = userReturns[msg.sender];
        require(userReturn > 0, "No returns available");

        userReturns[msg.sender] = 0;
        payable(msg.sender).transfer(userReturn);
    }
}
```

## Frontend Implementation

### index.js

```javascript
import { useState, useEffect } from "react";
import { ethers } from "ethers";
import dsic_abi from "../artifacts/contracts/DSIC.sol/DSIC.json";
import styles from './HomePage.module.css'; // Import the CSS module

export default function HomePage() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [dsic, setDSIC] = useState(undefined);
  const [balance, setBalance] = useState(undefined);
  const [contribution, setContribution] = useState(undefined);
  const [returns, setReturns] = useState(undefined);

  const [depositAmount, setDepositAmount] = useState(0);
  const [withdrawAmount, setWithdrawAmount] = useState(0);

  const contractAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"; // Replace with actual deployed contract address
  const dsicABI = dsic_abi.abi;

  useEffect(() => {
    if (window.ethereum) {
      setEthWallet(window.ethereum);
      getWallet();
    } else {
      console.log("MetaMask is not installed. Please install MetaMask to use this application.");
    }
  }, []);

  const getWallet = async () => {
    try {
      const accounts = await ethWallet.request({ method: "eth_requestAccounts" });
      handleAccount(accounts);
    } catch (error) {
      console.error("Error connecting to MetaMask:", error);
    }
  };

  const handleAccount = (accounts) => {
    if (accounts.length > 0) {
      console.log("Account connected: ", accounts[0]);
      setAccount(accounts[0]);
      getDSICContract();
    } else {
      console.log("No accounts found");
    }
  };

  const getDSICContract = () => {
    if (ethers.utils.isAddress(contractAddress)) {
      const provider = new ethers.providers.Web3Provider(ethWallet);
      const signer = provider.getSigner();
      const dsicContract = new ethers.Contract(contractAddress, dsicABI, signer);
      setDSIC(dsicContract);
    } else {
      console.error("Invalid contract address");
    }
  };

  const getBalance = async () => {
    if (dsic) {
      const balance = await dsic.getBalance();
      setBalance(balance);
    }
  };

  const getContribution = async () => {
    if (dsic && account) {
      const contribution = await dsic.getUserContribution(account);
      setContribution(contribution);
    }
  };

  const getReturns = async () => {
    if (dsic && account) {
      const returns = await dsic.getUserReturns(account);
      setReturns(returns);
    }
  };

  const deposit = async () => {
    if (dsic) {
      let tx = await dsic.deposit({ value: ethers.utils.parseEther(depositAmount.toString()) });
      await tx.wait();
      getBalance();
      getContribution();
    }
  };

  const withdraw = async () => {
    if (dsic) {
      let amount = ethers.utils.parseEther(withdrawAmount.toString());
      let tx = await dsic.withdraw(amount);
      await tx.wait();
      getBalance();
      getContribution();
    }
  };

  const claimReturns = async () => {
    if (dsic) {
      let tx = await dsic.claimReturns();
      await tx.wait();
      getReturns();
    }
  };

  const initUser = () => {
    if (!account) {
      return (
        <button className={styles.connectButton} onClick={getWallet}>
          Connect MetaMask Wallet
        </button>
      );
    }

    if (balance === undefined) {
      getBalance();
      getContribution();
      getReturns();
    }

    return (
      <div className={styles.dashboard}>
        <p className={styles.accountInfo}>Your Account: <strong>{account}</strong></p>
        <p className={styles.balanceInfo}>Total Balance: <strong>{balance && ethers.utils.formatEther(balance)} ETH</strong></p>
        <p className={styles.contributionInfo}>Your Contribution: <strong>{contribution && ethers.utils.formatEther(contribution)} ETH</strong></p>
        <p className={styles.returnsInfo}>Your Returns: <strong>{returns && ethers.utils.formatEther(returns)} ETH</strong></p>

        <div

 className={styles.depositWithdrawContainer}>
          <input 
            type="number" 
            value={depositAmount} 
            onChange={(e) => setDepositAmount(e.target.value)} 
            placeholder="Deposit Amount"
          />
          <button className={styles.actionButton} onClick={deposit}>Deposit</button>

          <input 
            type="number" 
            value={withdrawAmount} 
            onChange={(e) => setWithdrawAmount(e.target.value)} 
            placeholder="Withdraw Amount"
          />
          <button className={styles.actionButton} onClick={withdraw}>Withdraw</button>
          
          <button className={styles.actionButton} onClick={claimReturns}>Claim Returns</button>
        </div>
      </div>
    );
  };

  return <>{initUser()}</>;
}
```

### deploy.js

```javascript
async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const DSIC = await ethers.getContractFactory("DSIC");
  const dsic = await DSIC.deploy(1000000);

  console.log("DSIC contract deployed to:", dsic.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```
