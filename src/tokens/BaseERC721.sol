// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @title BaseERC721
/// @notice Enumerable, pausable NFT template with public + owner minting.
contract BaseERC721 is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    using Strings for uint256;

    uint256 public maxSupply;
    uint256 public mintPrice;
    uint256 private _nextId = 1;
    string public baseURI;

    error MintClosed();
    error WrongPayment();
    error SoldOut();
    error ExceedsMaxPerTxn(uint256 requested, uint256 allowed);

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        uint256 maxSupply_,
        uint256 mintPrice_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        baseURI = baseURI_;
        maxSupply = maxSupply_;
        mintPrice = mintPrice_;
    }

    function publicMint(address to) external payable returns (uint256 tokenId) {
        if (paused()) revert MintClosed();
        if (msg.value != mintPrice) revert WrongPayment();
        tokenId = _mintOne(to);
    }

    function ownerMint(address to) external onlyOwner returns (uint256 tokenId) {
        tokenId = _mintOne(to);
    }

    function _mintOne(address to) private returns (uint256 tokenId) {
        if (_nextId > maxSupply) revert SoldOut();
        tokenId = _nextId++;
        _safeMint(to, tokenId);
    }

    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
