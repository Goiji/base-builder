// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BaseERC721.sol";

/// @title BaseERC721Metadata
/// @notice Adds per-token JSON metadata served from a data URI template.
contract BaseERC721Metadata is BaseERC721 {
    string public contractURI;
    mapping(uint256 => string) private _tokenURIs;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        uint256 maxSupply_,
        uint256 mintPrice_
    ) BaseERC721(name_, symbol_, baseURI_, maxSupply_, mintPrice_) {}

    function setTokenURI(uint256 tokenId, string memory uri) external onlyOwner {
        _tokenURIs[tokenId] = uri;
    }

    function setContractURI(string memory uri) external onlyOwner {
        contractURI = uri;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        bytes memory u = bytes(_tokenURIs[tokenId]);
        if (u.length > 0) return _tokenURIs[tokenId];
        return super.tokenURI(tokenId);
    }
}
