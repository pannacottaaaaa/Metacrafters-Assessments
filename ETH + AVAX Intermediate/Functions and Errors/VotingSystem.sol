// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public owner;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string description;
        uint256 voteCount;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public votes; // Tracks if an address has voted on a proposal

    event ProposalCreated(uint256 id, string description);
    event Voted(uint256 proposalId, address voter);

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
        proposalCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function createProposal(string memory description) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, description, 0, true);

        emit ProposalCreated(proposalCount, description);
    }

    function vote(uint256 proposalId) public {
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(!votes[msg.sender][proposalId], "You have already voted on this proposal");

        proposals[proposalId].voteCount++;
        votes[msg.sender][proposalId] = true;

        emit Voted(proposalId, msg.sender);
    }

    function getProposal(uint256 proposalId) public view returns (string memory description, uint256 voteCount) {
        require(proposals[proposalId].exists, "Proposal does not exist");
        return (proposals[proposalId].description, proposals[proposalId].voteCount);
    }
}
