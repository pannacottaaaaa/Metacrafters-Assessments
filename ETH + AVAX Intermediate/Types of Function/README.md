# MyToken Project

A simple ERC20 token smart contract deployed on the Ethereum blockchain.

## Description

This project involves creating and deploying an ERC20 token named "MyToken" (MTK) on the Ethereum blockchain. The contract utilizes the OpenZeppelin library to ensure security and functionality. The contract owner has the ability to mint new tokens, and any user can burn their own tokens.

## Getting Started

### Installing

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/mytoken-project.git
    ```
2. Navigate to the project directory:
    ```bash
    cd mytoken-project
    ```
3. Ensure you have Node.js and npm installed. If not, download and install them from [Node.js official website](https://nodejs.org/).

4. Install Truffle and OpenZeppelin:
    ```bash
    npm install -g truffle
    npm install @openzeppelin/contracts
    ```

### Executing program

1. Compile the smart contract:
    ```bash
    truffle compile
    ```
2. Deploy the contract to the desired Ethereum network (e.g., Rinkeby, Mainnet):
    ```bash
    truffle migrate --network rinkeby
    ```

## Help

If you encounter any issues during the installation or deployment, ensure that:
- You have a stable internet connection.
- Your Ethereum client (e.g., MetaMask) is properly configured and connected to the desired network.
- Your wallet has sufficient ETH to cover gas fees.

For additional help, refer to the Truffle documentation:
```bash
truffle help
```

## Authors

- [pannacottaaaaa](https://github.com/pannacottaaaaa)

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Code
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(address initialOwner) ERC20("MyToken", "MTK") Ownable(initialOwner) {
        // Initial mint (optional)
        _mint(initialOwner, 1000 * 10 ** decimals());
    }

    // Only the owner can mint new tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Any user can burn their own tokens
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Override transfer function
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        return super.transfer(recipient, amount);
    }
}
```
