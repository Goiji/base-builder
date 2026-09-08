// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { console2 } from "forge-std/console2.sol";
import "../src/tokens/BaseERC20.sol";
import "../src/MerkleAirdrop.sol";
import "./helpers.sol";

/// @notice Deploys a demo token + airdrop and funds the drop.
contract DeployDemo is Script, DeployHelpers {
    function run() external {
        uint256 supply = 1_000_000e18;
        vm.startBroadcast();
        BaseERC20 token = new BaseERC20("Demo", "DEMO", 18, supply);
        MerkleAirdrop drop = new MerkleAirdrop(
            address(token),
            bytes32(vm.envBytes32("MERKLE_ROOT")),
            vm.envUint("AIRDROP_END_TS")
        );
        token.mint(address(drop), 100_000e18);
        vm.stopBroadcast();

        console2.log("token:", address(token));
        console2.log("drop:", address(drop));
    }
}
