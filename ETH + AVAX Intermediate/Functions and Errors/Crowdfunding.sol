// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint256 public campaignCount;

    struct Campaign {
        uint256 id;
        address payable creator;
        string title;
        string description;
        uint256 goal;
        uint256 pledged;
        uint256 deadline;
        bool exists;
        bool completed;
    }

    mapping(uint256 => Campaign) public campaigns;
    mapping(address => mapping(uint256 => uint256)) public pledges; // Tracks pledges of each address for each campaign

    event CampaignCreated(uint256 id, string title, uint256 goal, uint256 deadline);
    event Pledged(uint256 campaignId, address backer, uint256 amount);
    event Withdrawn(uint256 campaignId, address backer, uint256 amount);
    event CampaignCompleted(uint256 campaignId, address creator, uint256 amount);

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
        campaignCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier campaignExists(uint256 campaignId) {
        require(campaigns[campaignId].exists, "Campaign does not exist");
        _;
    }

    function createCampaign(
        string memory title,
        string memory description,
        uint256 goal,
        uint256 duration
    ) public {
        require(goal > 0, "Goal should be greater than zero");
        require(duration > 0, "Duration should be greater than zero");

        campaignCount++;
        uint256 deadline = block.timestamp + duration;

        campaigns[campaignCount] = Campaign(
            campaignCount,
            payable(msg.sender),
            title,
            description,
            goal,
            0,
            deadline,
            true,
            false
        );

        emit CampaignCreated(campaignCount, title, goal, deadline);
    }

    function pledge(uint256 campaignId) public payable campaignExists(campaignId) {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has ended");
        require(!campaign.completed, "Campaign is already completed");

        campaign.pledged += msg.value;
        pledges[msg.sender][campaignId] += msg.value;

        emit Pledged(campaignId, msg.sender, msg.value);
    }

    function withdraw(uint256 campaignId) public campaignExists(campaignId) {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp >= campaign.deadline, "Campaign is still ongoing");
        require(!campaign.completed, "Campaign is already completed");

        if (campaign.pledged >= campaign.goal) {
            campaign.completed = true;
            campaign.creator.transfer(campaign.pledged);

            emit CampaignCompleted(campaignId, campaign.creator, campaign.pledged);
        } else {
            uint256 amount = pledges[msg.sender][campaignId];
            require(amount > 0, "No funds to withdraw");

            pledges[msg.sender][campaignId] = 0;
            payable(msg.sender).transfer(amount);

            emit Withdrawn(campaignId, msg.sender, amount);
        }
    }

    function getCampaign(uint256 campaignId) public view returns (
        string memory title,
        string memory description,
        uint256 goal,
        uint256 pledged,
        uint256 deadline,
        bool completed
    ) {
        require(campaigns[campaignId].exists, "Campaign does not exist");

        Campaign storage campaign = campaigns[campaignId];
        return (
            campaign.title,
            campaign.description,
            campaign.goal,
            campaign.pledged,
            campaign.deadline,
            campaign.completed
        );
    }
}
