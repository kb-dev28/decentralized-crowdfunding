// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Campaign} from "./Campaign.sol";

/// @title CrowdfundingFactory
/// @notice Deploys and registers one Campaign contract per fundraising campaign.
contract CrowdfundingFactory {
    uint256 public campaignCount;
    address[] public campaigns;

    event CampaignCreated(
        uint256 indexed campaignId,
        address indexed campaignAddress,
        address indexed creator,
        address beneficiary,
        uint256 goal,
        uint256 deadline,
        string metadataURI
    );

    /// @notice Deploy a new Campaign; msg.sender becomes the campaign creator.
    /// @param beneficiary Address that may release funds after a successful campaign.
    /// @param goal Funding target in wei.
    /// @param deadline Unix timestamp; must be in the future (validated in Campaign).
    /// @param metadataURI Off-chain metadata pointer (IPFS, API URL, etc.).
    /// @return campaignAddress Address of the deployed Campaign instance.
    function createCampaign(
        address beneficiary,
        uint256 goal,
        uint256 deadline,
        string calldata metadataURI
    ) external returns (address campaignAddress) {
        Campaign campaign = new Campaign(msg.sender, beneficiary, goal, deadline, metadataURI);
        campaignAddress = address(campaign);

        uint256 campaignId = campaignCount;
        campaigns.push(campaignAddress);
        campaignCount = campaignId + 1;

        emit CampaignCreated(
            campaignId, campaignAddress, msg.sender, beneficiary, goal, deadline, metadataURI
        );
    }

    /// @notice Returns campaign contract address by index (0 .. campaignCount - 1).
    function getCampaign(uint256 index) external view returns (address) {
        return campaigns[index];
    }
}
