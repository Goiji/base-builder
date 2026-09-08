// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { console2 } from "forge-std/console2.sol";
import "../src/BondingCurve.sol";
import "./helpers.sol";

contract DeployCurve is Script, DeployHelpers {
    function run() external {
        uint256 slope = vm.envUint("CURVE_SLOPE");
        uint256 baseFee = vm.envUint("CURVE_BASE_FEE");

        vm.startBroadcast();
        BondingCurve curve = new BondingCurve(slope, baseFee);
        vm.stopBroadcast();

        console2.log("BondingCurve deployed at:", address(curve));
    }
}
