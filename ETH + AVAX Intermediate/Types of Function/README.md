# MyToken - ERC20 Token with Ownership and Minting/Burning Features

## Description

MyToken is an ERC20 token smart contract implemented in Solidity. It includes functionality for token minting by the owner and burning tokens by any user.

## Smart Contract Code

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
}
```

## Getting Started

### Installing

Clone the repository:
```bash
git clone https://github.com/your-username/MyToken.git
```

Install dependencies:
```bash
npm install
```

### Executing program

Deploy the smart contract using Remix or another Ethereum IDE.

### Help

For common problems or issues, please refer to the Solidity documentation or Ethereum community forums.

### Authors

- [pannacottaaaaa]([https://github.com/your-username](https://github.com/pannacottaaaaa))

### License

This project is licensed under the MIT License.
