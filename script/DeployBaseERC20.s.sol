// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { console2 } from "forge-std/console2.sol";
import "../src/tokens/BaseERC20.sol";
import "./helpers.sol";

/// @notice Deploy a BaseERC20. Usage:
///   forge script script/DeployBaseERC20.s.sol --rpc-url $BASE_RPC --broadcast
contract DeployBaseERC20 is Script, DeployHelpers {
    function run() external {
        string memory name = vm.envString("TOKEN_NAME");
        string memory symbol = vm.envString("TOKEN_SYMBOL");
        uint256 supply = vm.envUint("TOKEN_MAX_SUPPLY");

        vm.startBroadcast();
        BaseERC20 token = new BaseERC20(name, symbol, 18, supply);
        vm.stopBroadcast();

        console2.log("BaseERC20 deployed at:", address(token));
    }
}
