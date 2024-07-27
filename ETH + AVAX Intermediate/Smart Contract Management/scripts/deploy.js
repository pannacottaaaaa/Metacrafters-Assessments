// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const initBalance = ethers.utils.parseEther("1"); // Initial balance in ethers
  const DSIC = await hre.ethers.getContractFactory("DSIC");
  const dsic = await DSIC.deploy(initBalance);
  await dsic.deployed();

  console.log(`DSIC contract with balance of ${ethers.utils.formatEther(initBalance)} ETH deployed to ${dsic.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
