// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {CrowdfundingFactory} from "../src/CrowdfundingFactory.sol";
import {Campaign} from "../src/Campaign.sol";

contract CrowdfundingFactoryTest is Test {
    CrowdfundingFactory internal factory;

    address internal creator = makeAddr("creator");
    address internal beneficiary = makeAddr("beneficiary");
    uint256 internal constant GOAL = 2 ether;
    string internal constant METADATA_URI = "ipfs://factory-test-campaign";

    uint256 internal deadline;

    function setUp() public {
        factory = new CrowdfundingFactory();
        deadline = block.timestamp + 30 days;
    }

    function test_CreateCampaign_IncrementsCount() public {
        vm.prank(creator);
        factory.createCampaign(beneficiary, GOAL, deadline, METADATA_URI);

        assertEq(factory.campaignCount(), 1);
        assertEq(factory.getCampaign(0), factory.campaigns(0));
    }

    function test_CreateCampaign_ReturnsContractWithCode() public {
        vm.prank(creator);
        address campaignAddress =
            factory.createCampaign(beneficiary, GOAL, deadline, METADATA_URI);

        assertGt(campaignAddress.code.length, 0);
        assertEq(Campaign(campaignAddress).creator(), creator);
        assertEq(Campaign(campaignAddress).beneficiary(), beneficiary);
        assertEq(Campaign(campaignAddress).goal(), GOAL);
    }

    function test_CreateCampaign_EmitsEvent() public {
        vm.prank(creator);
        vm.recordLogs();
        address campaignAddress =
            factory.createCampaign(beneficiary, GOAL, deadline, METADATA_URI);

        Vm.Log[] memory logs = vm.getRecordedLogs();
        assertEq(logs.length, 1);
        assertEq(logs[0].emitter, address(factory));

        assertEq(logs[0].topics[1], bytes32(uint256(0)));
        assertEq(address(uint160(uint256(logs[0].topics[2]))), campaignAddress);
        assertEq(address(uint160(uint256(logs[0].topics[3]))), creator);
    }

    function test_CreateCampaign_MultipleCampaigns() public {
        vm.startPrank(creator);
        factory.createCampaign(beneficiary, GOAL, deadline, METADATA_URI);
        factory.createCampaign(beneficiary, GOAL, deadline + 1, "ipfs://second");
        vm.stopPrank();

        assertEq(factory.campaignCount(), 2);
        assertTrue(factory.getCampaign(0) != factory.getCampaign(1));
    }
}
