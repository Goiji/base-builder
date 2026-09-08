// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IBaseTokenFactory {
    /// @notice Emitted after a token contract is deployed.
    /// @param deployer Account that triggered the deployment.
    /// @param token Address of the newly deployed contract.
    event TokenDeployed(address indexed deployer, address indexed token);

    /// @notice Deploys a new ERC20 token and returns its address.
    function deployERC20(
        string calldata name_,
        string calldata symbol_,
        uint256 initialSupply
    ) external returns (address token);
}
