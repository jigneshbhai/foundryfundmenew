// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/FundMe.sol";
import "./mocks/MockV3Aggregator.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    MockV3Aggregator mockV3Aggregator;

    address owner = address(1);
    uint256 constant STARTING_PRICE = 2000 * 10 ** 8; // $2000 per ETH
    uint256 constant MINIMUM_USD = 5 * 10 ** 18;

    function setUp() public {
        mockV3Aggregator = new MockV3Aggregator(8, int256(STARTING_PRICE));
        vm.prank(owner);
        fundMe = new FundMe(address(mockV3Aggregator));
    }

    function testConstructorSetsOwner() public {
        assertEq(fundMe.getOwner(), owner);
    }

    function testFundRevertsIfBelowMinimum() public {
        vm.expectRevert("You need to spend more ETH!");
        fundMe.fund{value: 1 wei}();
    }

    function testFundUpdatesAddressToAmountFunded() public {
    // Fund with sufficient ETH based on mock price
    uint256 sufficientValue = 0.01 ether; // Ensure it's above the required amount
    address funder = address(2);
    
    vm.deal(funder, sufficientValue); // Fund the account with ETH
    vm.prank(funder);
    fundMe.fund{value: sufficientValue}();

    // Check that the amount was correctly updated
    assertEq(fundMe.getAddressToAmountFunded(funder), sufficientValue);
}


    function testMockUpdatesPrice() public {
        int256 newPrice = 3000 * 10 ** 8;
        mockV3Aggregator.updateAnswer(newPrice);
        assertEq(mockV3Aggregator.latestAnswer(), newPrice);
    }

    function testWithdrawOwnerOnly() public {
        vm.prank(address(2)); // Non-owner account
        vm.expectRevert(FundMe__NotOwner.selector);
        fundMe.withdraw();
    }

    function testWithdrawResetsState() public {
        address funder = address(3);
        vm.deal(funder, 1 ether);
        vm.prank(funder);
        fundMe.fund{value: 1 ether}();

        vm.prank(owner);
        fundMe.withdraw();

        assertEq(fundMe.getAddressToAmountFunded(funder), 0);
        assertEq(address(fundMe).balance, 0);
    }
}
