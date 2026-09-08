// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../tokens/BaseERC20.sol";
import "../interfaces/IBaseTokenFactory.sol";

/// @title BaseTokenFactory
/// @notice Deterministic (CREATE2) deployer for BaseERC20 with persistent registry.
contract BaseTokenFactory is Ownable, IBaseTokenFactory {
    mapping(bytes32 => address) public deployments;
    mapping(address => bytes32) public saltOf;

    bytes32 public constant INIT_CODE_HASH = keccak256(type(BaseERC20).creationCode);

    event TokenDeployed(address indexed deployer, address indexed token, bytes32 salt);

    constructor() Ownable(msg.sender) {}

    function deployERC20(
        string calldata name_,
        string calldata symbol_,
        uint8 decimals_,
        uint256 maxSupply_,
        bytes32 salt
    ) external returns (address token) {
        bytes32 addrSalt = keccak256(abi.encode(msg.sender, salt));
        token = Create2.deploy(0, addrSalt, abi.encodePacked(
            type(BaseERC20).creationCode,
            abi.encode(name_, symbol_, decimals_, maxSupply_)
        ));
        deployments[addrSalt] = token;
        saltOf[token] = addrSalt;
        emit TokenDeployed(msg.sender, token, addrSalt);
    }

    /// @notice Predicts the address a salt will deploy to for a given deployer.
    function predictERC20(address deployer, bytes32 salt) public view returns (address) {
        bytes32 addrSalt = keccak256(abi.encode(deployer, salt));
        return Create2.computeAddress(
            addrSalt,
            keccak256(abi.encodePacked(type(BaseERC20).creationCode, INIT_CODE_HASH))
        );
    }
}
