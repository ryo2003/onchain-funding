// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "hardhat/console.sol";

contract FundPortal {
    address public owner;
    uint256 public campaignCount = 0;

    struct Campaign {
        uint256 fundingGoal;
        uint256 deadline;
        address payable beneficiary;
        uint256 amountRaised;
        bool completed;
        //address[] contributors;
    }

    event CampaignCreated(
        uint256 fundingGoal,
        uint256 deadline,
        address beneficiary
    );

    // struct Contributor {
    //     address contributorAddress;
    //     uint256 amount;
    //     bool refunded;
    // }

    Campaign[] public campaigns;

    constructor() {
        owner = msg.sender;
        //in run.js, you can set the sender by adding .connect(sender) before the function
    }

    function createCampaign(
        uint256 _fundingGoal,
        uint256 _deadline,
        address payable _beneficiary
    ) public {
        Campaign memory newCampaign = Campaign({
            fundingGoal: _fundingGoal,
            deadline: _deadline,
            beneficiary: _beneficiary,
            amountRaised: 0,
            completed: false
            //contributors: []
        });
        campaignCount++;
        campaigns.push(newCampaign);
        console.log("%s started a campaign!", _beneficiary);
        console.log("%d is the funding goal!", newCampaign.fundingGoal);
        emit CampaignCreated(_fundingGoal, _deadline, _beneficiary);
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getCampaignCount() public view returns (uint256) {
        console.log("We have %d campaigns!", campaignCount);
        return campaignCount;
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        return campaigns;
    }

    function getCampaignInfo(
        uint256 _id
    ) public view returns (uint256, uint256, address, uint256, bool) {
        Campaign storage campaign = campaigns[_id];
        return (
            campaign.fundingGoal,
            campaign.deadline,
            campaign.beneficiary,
            campaign.amountRaised,
            campaign.completed
        );
    }

    //sending eth to the beneficiary
    function sendEther(address payable recipient) public payable {
        require(msg.value > 0, "Amount must be greater than zero.");
        recipient.transfer(msg.value);
    }
}

/*
contract Crowdfunding {
    address public owner;
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => Contributor)) public contributors;

    struct Campaign {
        uint256 fundingTarget;
        uint256 deadline;
        address payable beneficiary;
        uint256 amountRaised;
        bool completed;
    }

    struct Contributor {
        uint256 amountContributed;
        bool rewarded;
    }

    event CampaignCreated(uint256 campaignId);
    event CampaignFunded(
        uint256 campaignId,
        address contributor,
        uint256 amountContributed
    );
    event CampaignCompleted(uint256 campaignId);

    constructor() {
        owner = msg.sender;
    }

    function createCampaign(
        uint256 fundingTarget,
        uint256 deadline,
        address payable beneficiary
    ) public {
        require(msg.sender == owner, "Only the owner can create a campaign.");
        uint256 campaignId = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        );
        campaigns[campaignId] = Campaign(
            fundingTarget,
            deadline,
            beneficiary,
            0,
            false
        );
        emit CampaignCreated(campaignId);
    }

    function fundCampaign(uint256 campaignId) public payable {
        Campaign storage campaign = campaigns[campaignId];
        require(
            block.timestamp <= campaign.deadline,
            "This campaign has already ended."
        );
        require(
            !campaign.completed,
            "This campaign has already been completed."
        );
        campaign.amountRaised += msg.value;
        contributors[campaignId][msg.sender].amountContributed += msg.value;
        emit CampaignFunded(campaignId, msg.sender, msg.value);
    }

    function completeCampaign(uint256 campaignId) public {
        Campaign storage campaign = campaigns[campaignId];
        require(
            block.timestamp > campaign.deadline,
            "This campaign has not yet ended."
        );
        require(
            !campaign.completed,
            "This campaign has already been completed."
        );
        if (campaign.amountRaised >= campaign.fundingTarget) {
            campaign.beneficiary.transfer(campaign.amountRaised);
        } else {
            for (uint256 i = 0; i < campaignId; i++) {
                Contributor storage contributor = contributors[campaignId][
                    msg.sender
                ];
                if (
                    contributor.amountContributed > 0 && !contributor.rewarded
                ) {
                    contributor.rewarded = true;
                    payable(msg.sender).transfer(contributor.amountContributed);
                }
            }
        }
        campaign.completed = true;
        emit CampaignCompleted(campaignId);
    }
}
*/
