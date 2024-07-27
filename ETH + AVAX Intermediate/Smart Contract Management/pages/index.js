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

        <div className={styles.transactionSection}>
          <h3>Deposit</h3>
          <input
            className={styles.inputField}
            type="number"
            value={depositAmount}
            onChange={(e) => setDepositAmount(e.target.value)}
            placeholder="Enter deposit amount"
          />
          <button className={styles.transactionButton} onClick={deposit}>Deposit</button>
        </div>

        <div className={styles.transactionSection}>
          <h3>Withdraw</h3>
          <input
            className={styles.inputField}
            type="number"
            value={withdrawAmount}
            onChange={(e) => setWithdrawAmount(e.target.value)}
            placeholder="Enter withdraw amount"
          />
          <button className={styles.transactionButton} onClick={withdraw}>Withdraw</button>
        </div>

        <button className={styles.claimButton} onClick={claimReturns}>Claim Returns</button>
      </div>
    );
  };

  return (
    <main className={styles.container}>
      <header className={styles.header}>
        <h1>Welcome to the Decentralized Savings and Investment Club!</h1>
      </header>
      {initUser()}
    </main>
  );
}
