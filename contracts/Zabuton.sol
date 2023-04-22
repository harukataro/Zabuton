// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "operator-filter-registry/src/DefaultOperatorFilterer.sol";
import "base64-sol/base64.sol";
import "./ERC4906.sol";
import "./OperatorRole.sol";
import "./IZabutonImage.sol";
import "hardhat/console.sol";

contract Zabuton is ERC721, ERC4906, ERC2981, DefaultOperatorFilterer, OperatorRole {
    using Counters for Counters.Counter;
    Counters.Counter private currentTokenId;

    uint256 private MAX_SUPPLY = 1000;
    uint256 private MAX_AL_SUPPLY = 500;
    uint256 private MAX_PER_WALLET = 5;

    mapping(uint256 => uint256) private myNumber;
    mapping(address => bool) private allowedMinters;
    uint256 private numOfAllowedMinters;
    bool private mintable;
    bool private publicMint;
    address private zabutonImageAddress;

    event moveRandom(uint256 winner, uint256 loser);
    event LockStatusChange(uint256 tokenId, bool status);

    constructor() ERC721("Zabuton", "ZAB") {}

    function mint() public payable returns (uint256) {
        require(mintable, "Mint is not Started");
        require(publicMint || allowedMinters[msg.sender], "Sender no in AL / before public sale");
        require(currentTokenId.current() < MAX_SUPPLY, "Mint limit exceeded");
        require(balanceOf(msg.sender) < MAX_PER_WALLET, "Max per wallet reached");

        currentTokenId.increment();
        uint256 newItemId = currentTokenId.current();
        _mint(msg.sender, newItemId);
        myNumber[newItemId] = 1;
        return newItemId;
    }

    /// @dev ownerMint
    /// @param recipient address of recipient
    function ownerMintTo(address recipient) public onlyOwner returns (uint256) {
        require(currentTokenId.current() < MAX_SUPPLY, "Mint limit exceeded");
        require(balanceOf(recipient) < MAX_PER_WALLET, "Max per wallet reached");

        currentTokenId.increment();
        uint256 newItemId = currentTokenId.current();
        _mint(recipient, newItemId);
        myNumber[newItemId] = 1;
        return newItemId;
    }

    // ******************** Allow list control ******************** //

    /// @dev add Aloow list address onlyOwner
    /// @param _minters address array
    function addAllowedMinters(address[] memory _minters) public onlyOperator {
        require(numOfAllowedMinters + _minters.length <= MAX_AL_SUPPLY, "Allow list is full");
        for (uint256 i = 0; i < _minters.length; i++) {
            if (allowedMinters[_minters[i]] == false) {
                allowedMinters[_minters[i]] = true;
                numOfAllowedMinters += 1;
            }
        }
    }

    /// @dev remove Allow list address onlyOwner
    /// @param _minters address array
    function removeAllowedMinters(address[] memory _minters) public onlyOperator {
        for (uint256 i = 0; i < _minters.length; i++) {
            if (allowedMinters[_minters[i]]) {
                allowedMinters[_minters[i]] = false;
                numOfAllowedMinters -= 1;
            }
        }
    }

    /// @dev check Allow list address
    /// @param _minter address
    function isAllowedMinter(address _minter) public view returns (bool) {
        return allowedMinters[_minter];
    }

    // ******************** metadata control ******************** //
    // metadata control
    /// @dev change Number metadata for specific token id
    /// @param _tokenId token id
    /// @param _number number
    function changeNumber(uint256 _tokenId, uint256 _number) public onlyOperator {
        require(_exists(_tokenId), "tokenId must be exist");
        require(_number <= 10, "Number must be smaller than 10");
        myNumber[_tokenId] = _number;
        emit MetadataUpdate(_tokenId);
    }

    /// @dev ramdomly increase number metadata of one of token and decrease number metadata of another token
    /// this is for testing purpose as public. anyone can call this function.

    ///@dev get number metadata of Token Id
    function getNumber(uint256 _tokenId) public view returns (uint256) {
        return myNumber[_tokenId];
    }

    // ******************** tokenURI ******************** //
    /// @dev get metadata for specific token id
    /// @param _tokenId token id
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "tokenId must be exist");
        uint256 number = myNumber[_tokenId];
        string memory numberStr = Strings.toString(myNumber[_tokenId]);

        IZabutonImage zabutonImage = IZabutonImage(zabutonImageAddress);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Zabuton #',
                        Strings.toString(_tokenId),
                        '","description": "Zabuton is amazing","attributes": [{"trait_type":"Number","value":"',
                        numberStr,
                        '"}],"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(zabutonImage.getImage(number))),
                        '"}'
                    )
                )
            )
        );
        string memory output = string(abi.encodePacked("data:application/json;base64,", json));
        return output;
    }

    // ******************** Owner functions ******************** //

    /// @dev withdraw all balance to owner
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    /// @dev get mintable state
    function getMintable() public view returns (bool) {
        return mintable;
    }

    /// @dev set mintable state
    function setMintable(bool _status) public onlyOwner {
        mintable = _status;
    }

    /// @dev get public mint state
    function getPublicMint() public view returns (bool) {
        return publicMint;
    }

    /// @dev set public mint state
    function setPublicMint(bool _status) public onlyOwner {
        publicMint = _status;
    }

    /// @dev get ZabutonImage contract address for URI building
    function getZabutonImageContractAddress() public view returns (address) {
        return zabutonImageAddress;
    }

    /// @dev set ZabutonImage contract address for URI building
    function setZabutonImageContractAddress(address _zabutonImageAddress) public onlyOwner {
        zabutonImageAddress = _zabutonImageAddress;
    }

    // ******************** DefaultOperatorFilterer ******************** //
    function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    // ******************** ERC2981 ******************** //
    // ERC2981
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    // ******************** ERC165 ******************** //
    /**
     * @dev IERC165-supportsInterface
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981, ERC4906) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
