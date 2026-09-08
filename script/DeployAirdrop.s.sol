// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { console2 } from "forge-std/console2.sol";
import "../src/MerkleAirdrop.sol";
import "./helpers.sol";

contract DeployAirdrop is Script, DeployHelpers {
    function run() external {
        address token = vm.envAddress("AIRDROP_TOKEN");
        bytes32 root = bytes32(vm.envBytes32("MERKLE_ROOT"));
        uint256 end = vm.envUint("AIRDROP_END_TS");

        vm.startBroadcast();
        MerkleAirdrop drop = new MerkleAirdrop(token, root, end);
        vm.stopBroadcast();

        console2.log("MerkleAirdrop deployed at:", address(drop));
    }
}
