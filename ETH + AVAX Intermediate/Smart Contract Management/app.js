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
