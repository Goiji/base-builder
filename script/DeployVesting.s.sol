// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { console2 } from "forge-std/console2.sol";
import "../src/TokenVesting.sol";
import "./helpers.sol";

contract DeployVesting is Script, DeployHelpers {
    function run() external {
        address token = vm.envAddress("VEST_TOKEN");
        address beneficiary = vm.envAddress("VEST_BENEFICIARY");
        uint256 start = vm.envUint("VEST_START_TS");
        uint256 cliff = vm.envUint("VEST_CLIFF");
        uint256 duration = vm.envUint("VEST_DURATION");

        vm.startBroadcast();
        TokenVesting vesting = new TokenVesting(token, beneficiary, start, cliff, duration);
        vm.stopBroadcast();

        console2.log("TokenVesting deployed at:", address(vesting));
    }
}
