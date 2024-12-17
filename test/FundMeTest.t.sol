// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import  {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
     FundMe public fundMe;

    function setUp() external {
     fundMe = new FundMe(0xB7856D53fB966A0906280A5736DC714da0eF0f21);
    }

     function testMinimumDollarIsFive () public {
          assertEq(fundMe.MINIMUM_USD(), 5e18);
     }

     
    

}

