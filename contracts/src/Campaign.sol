// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title Campaign
/// @notice Single crowdfunding campaign instance (deployed by CrowdfundingFactory).
/// @dev donate() and releaseFunds() are added in later steps (Etapa 1.3–1.5).
contract Campaign is ReentrancyGuard {
    enum CampaignState {
        Active,
        Successful,
        Failed,
        Released
    }

    event DonationReceived(
        address indexed donor,
        uint256 amount,
        uint256 newTotalRaised,
        uint256 contributorCount
    );

    event FundsReleased(address indexed beneficiary, uint256 amount, uint256 timestamp);

    event CampaignStateUpdated(CampaignState indexed oldState, CampaignState indexed newState);

    address public immutable creator;
    address public immutable beneficiary;
    uint256 public immutable goal;
    uint256 public immutable deadline;

    string public metadataURI;

    uint256 public amountRaised;
    CampaignState public state;
    uint256 public contributorCount;

    mapping(address => bool) public hasContributed;

    error InvalidGoal();
    error InvalidDeadline();
    error InvalidBeneficiary();

    constructor(
        address _creator,
        address _beneficiary,
        uint256 _goal,
        uint256 _deadline,
        string memory _metadataURI
    ) {
        if (_goal == 0) revert InvalidGoal();
        if (_deadline <= block.timestamp) revert InvalidDeadline();
        if (_beneficiary == address(0)) revert InvalidBeneficiary();

        creator = _creator;
        beneficiary = _beneficiary;
        goal = _goal;
        deadline = _deadline;
        metadataURI = _metadataURI;
        state = CampaignState.Active;
    }
}
