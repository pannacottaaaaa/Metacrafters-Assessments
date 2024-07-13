# PROJECT - Degen Token (ERC-20): Unlocking the Future of Gaming on Avalanche Network

## Description

DegenToken is an ERC20 token designed for Degen Gaming on the Avalanche network. This token facilitates minting new tokens, transferring tokens between players, redeeming tokens for in-game items, checking token balances, and burning tokens that are no longer needed. It serves as the backbone of the Degen Gaming platform's virtual economy.

## Getting Started

### Installing

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/DegenToken.git
   cd DegenToken
   ```

2. Open the project in Remix IDE:
   - Navigate to [Remix IDE](https://remix.ethereum.org/).
   - Create a new file named `DegenToken.sol`.
   - Copy and paste the following contract code into `DegenToken.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    
    uint256 public constant REDEMPTION_RATE = 100;

    mapping(address => uint256) public itemsRedeemed;
    mapping(string => uint256) public itemCosts;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _mint(msg.sender, 10 * (10 ** uint256(decimals())));
        // Example items and their costs
        itemCosts["Sword"] = 100;
        itemCosts["Shield"] = 150;
        itemCosts["Potion"] = 50;
    }

    function redeemItems(string memory itemName, uint256 quantity) public {
        require(itemCosts[itemName] > 0, "Item does not exist");
        uint256 cost = itemCosts[itemName] * quantity;
        require(balanceOf(msg.sender) >= cost, "Not enough tokens to redeem items");

        itemsRedeemed[msg.sender] += quantity;
        _burn(msg.sender, cost);
    }

    function checkItemsRedeemed(address user) public view returns (uint256) {
        return itemsRedeemed[user];
    }

    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to burn");
        _burn(msg.sender, amount);
    }

    function setItemCost(string memory itemName, uint256 cost) public onlyOwner {
        itemCosts[itemName] = cost;
    }
}
```

### Executing Program

#### Deployment

1. **Compile the Contract:**
   - Open Remix IDE.
   - Select the `DegenToken.sol` file.
   - Go to the "Solidity Compiler" tab.
   - Click "Compile DegenToken.sol".

2. **Deploy the Contract:**
   - Go to the "Deploy & Run Transactions" tab.
   - Select `DegenToken` from the contract dropdown.
   - Choose the "Injected Web3" environment if using MetaMask, or "Remix VM" for local testing.
   - Click "Deploy".
   - Confirm the transaction if using MetaMask.

#### Interacting with the Contract

1. **Mint Tokens:**
   - Function: `mintTokens(address to, uint256 amount)`
   - Example:
     ```sh
     mintTokens("0xRecipientAddress", 1000)
     ```

2. **Transfer Tokens:**
   - Function: `transfer(address to, uint256 amount)`
   - Example:
     ```sh
     transfer("0xRecipientAddress", 500)
     ```

3. **Redeem Tokens:**
   - Function: `redeemItems(string memory itemName, uint256 quantity)`
   - Example:
     ```sh
     redeemItems("Sword", 2)
     ```

4. **Check Balance:**
   - Function: `checkBalance(address account)`
   - Example:
     ```sh
     checkBalance("0xYourAddressHere")
     ```

5. **Burn Tokens:**
   - Function: `burnTokens(uint256 amount)`
   - Example:
     ```sh
     burnTokens(300)
     ```

6. **Check Redeemed Items:**
   - Function: `checkItemsRedeemed(address user)`
   - Example:
     ```sh
     checkItemsRedeemed("0xYourAddressHere")
     ```

7. **Set Item Cost:**
   - Function: `setItemCost(string memory itemName, uint256 cost)`
   - Example:
     ```sh
     setItemCost("Axe", 200)
     ```

### Help

For common problems or issues, refer to the following tips:

1. **Compilation Errors:**
   - Ensure you are using the correct Solidity version (`^0.8.23`).

2. **Deployment Issues:**
   - Make sure you have enough funds in your account for deploying the contract.
   - Check your network settings if you are deploying to a testnet.

3. **Transaction Errors:**
   - Verify the input parameters (addresses, amounts) are correct and valid.

For additional help, you can run:
```sh
remix help
```

## Authors

- **pannacottaaaaa** - *Student* - [Your GitHub Profile](https://github.com/pannacottaaaaa)

## License

This project is licensed under the MIT License. See the LICENSE file for details.
