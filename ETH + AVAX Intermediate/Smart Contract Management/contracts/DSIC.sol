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
