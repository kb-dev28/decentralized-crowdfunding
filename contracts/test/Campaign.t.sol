// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Campaign} from "../src/Campaign.sol";

contract CampaignTest is Test {
    address internal creator = makeAddr("creator");
    address internal beneficiary = makeAddr("beneficiary");
    uint256 internal constant GOAL = 1 ether;
    string internal constant METADATA_URI = "ipfs://campaign-metadata";

    uint256 internal deadline;

    function setUp() public {
        deadline = block.timestamp + 7 days;
    }

    function test_Constructor_SetsFields() public {
        Campaign campaign =
            new Campaign(creator, beneficiary, GOAL, deadline, METADATA_URI);

        assertEq(campaign.creator(), creator);
        assertEq(campaign.beneficiary(), beneficiary);
        assertEq(campaign.goal(), GOAL);
        assertEq(campaign.deadline(), deadline);
        assertEq(campaign.metadataURI(), METADATA_URI);
        assertEq(campaign.amountRaised(), 0);
        assertEq(uint256(campaign.state()), uint256(Campaign.CampaignState.Active));
        assertEq(campaign.contributorCount(), 0);
        assertFalse(campaign.hasContributed(makeAddr("donor")));
    }

    function test_RevertWhen_GoalIsZero() public {
        vm.expectRevert(Campaign.InvalidGoal.selector);
        new Campaign(creator, beneficiary, 0, deadline, METADATA_URI);
    }

    function test_RevertWhen_DeadlineNotInFuture() public {
        vm.expectRevert(Campaign.InvalidDeadline.selector);
        new Campaign(creator, beneficiary, GOAL, block.timestamp, METADATA_URI);
    }

    function test_RevertWhen_DeadlineInPast() public {
        vm.expectRevert(Campaign.InvalidDeadline.selector);
        new Campaign(creator, beneficiary, GOAL, block.timestamp - 1, METADATA_URI);
    }

    function test_RevertWhen_BeneficiaryIsZeroAddress() public {
        vm.expectRevert(Campaign.InvalidBeneficiary.selector);
        new Campaign(creator, address(0), GOAL, deadline, METADATA_URI);
    }
}
