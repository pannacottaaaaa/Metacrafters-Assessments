// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SimpleGame {
    address public owner;
    uint256 public totalTokens;
    uint256 public gameCost;
    uint256 public winningNumber;
    
    event GamePlayed(address indexed player, uint256 guess, bool win, uint256 reward);
    event TokensClaimed(address indexed player, uint256 amount);

    mapping(address => uint256) public playerTokens;

    constructor(uint256 _initialTokens, uint256 _gameCost) {
        owner = msg.sender;
        totalTokens = _initialTokens;
        gameCost = _gameCost;
    }

    function playGame(uint256 guess) public payable {
        require(msg.value == gameCost, "Incorrect game cost");
        require(guess >= 1 && guess <= 10, "Guess must be between 1 and 10");
        
        // Generate a winning number between 1 and 10
        winningNumber = (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 10) + 1;
        
        bool win = (guess == winningNumber);
        uint256 reward = 0;
        
        if (win) {
            reward = gameCost * 2;
            require(totalTokens >= reward, "Not enough tokens in the contract");
            playerTokens[msg.sender] += reward;
            totalTokens -= reward;
        }

        emit GamePlayed(msg.sender, guess, win, reward);
    }

    function claimTokens() public {
        uint256 tokens = playerTokens[msg.sender];
        require(tokens > 0, "No tokens to claim");
        
        playerTokens[msg.sender] = 0;
        payable(msg.sender).transfer(tokens);
        
        emit TokensClaimed(msg.sender, tokens);
    }

    function addTokens(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can add tokens");
        totalTokens += amount;
    }

    receive() external payable {}
}
