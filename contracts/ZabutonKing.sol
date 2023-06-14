// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "base64-sol/base64.sol";
import "./ERC4906.sol";
import "./interfaces/IZabuton.sol";
import "./interfaces/IZabutonImage.sol";
import "./OperatorRole.sol";
import "hardhat/console.sol";

contract ZabutonKing is ERC721, ERC721Enumerable, ERC721Burnable, OperatorRole, ERC4906 {
    mapping(address => bool) private isHolder;
    mapping(uint256 => uint256) private rank;
    address[] private operators;
    address private zabutonAddress; // contract address for Zabuton as reference
    address private zabutonKingImageAddress; // contract address for Image fetch

    constructor() ERC721("ZabutonKing", "ZKNG") {}

    function safeMint(uint256 tokenId) public {
        address to = msg.sender;
        require(isHolder[to] == false, "You already have a ZabutonKing");
        require(isKing(to, tokenId), "You don't have a Zabuton with number 10");
        isHolder[to] = true;
        _safeMint(to, tokenId);

        // reset Zabuton to 1
        IZabuton zabutonContract = IZabuton(zabutonAddress);
        zabutonContract.changeNumber(tokenId, 1);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "tokenId must be exist");
        uint256 myRank = rank[_tokenId];

        require(zabutonKingImageAddress != address(0), "ZabutonKingImage address is not set");
        IZabutonImage zabutonKingImage = IZabutonImage(zabutonKingImageAddress);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Zabuton King #',
                        Strings.toString(_tokenId),
                        '","description": "Zabuton King is a NFT that can be minted by a user who has a Zabuton with number 10.",',
                        '"attributes": [{"trait_type":"Rank","value":"',
                        Strings.toString(myRank),
                        '"}],"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(zabutonKingImage.getImage(myRank))),
                        '"}'
                    )
                )
            )
        );
        string memory output = string(abi.encodePacked("data:application/json;base64,", json));
        return output;
    }

    function isKing(address to, uint256 _tokenId) internal view returns (bool) {
        IZabuton zabutonContract = IZabuton(zabutonAddress);

        if (zabutonContract.ownerOf(_tokenId) != to || zabutonContract.getNumber(_tokenId) != 10) {
            return false;
        }
        return true;
    }

    function getZabutonContractAddress() public view onlyOperator returns (address) {
        return zabutonAddress;
    }

    function setZabutonContractAddress(address _address) public onlyOperator {
        zabutonAddress = _address;
    }

    function getZabutonKingImageContractAddress() public view onlyOperator returns (address) {
        return zabutonKingImageAddress;
    }

    function setZabutonKingImageContractAddress(address _address) public onlyOperator {
        zabutonKingImageAddress = _address;
    }

    function getRank(uint256 _tokenId) public view returns (uint256) {
        require(_exists(_tokenId), "tokenId must be exist");
        return rank[_tokenId];
    }

    function setRank(uint256 _tokenId, uint256 _rank) public onlyOperator {
        require(_exists(_tokenId), "tokenId must be exist for setRank");
        require(0 <= _rank && _rank <= 4, "rank must be 0 to 4");
        rank[_tokenId] = _rank;
        emit MetadataUpdate(_tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
        require(from == address(0) || to == address(0), "This a SBT. It cannot be transferred. It can only be burned by the token owner.");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable, ERC4906) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
