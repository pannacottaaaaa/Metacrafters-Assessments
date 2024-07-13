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
