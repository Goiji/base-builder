// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { console2 } from "forge-std/console2.sol";

contract DeployHelpers is Script {
    function deployerAddress() internal view returns (address) {
        return vm.addr(vm.envUint("PRIVATE_KEY"));
    }
}
