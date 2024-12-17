// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external {
        vm.startBroadcast();
        new FundMe(0xB7856D53fB966A0906280A5736DC714da0eF0f21);
        vm.stopBroadcast();
    }
}
