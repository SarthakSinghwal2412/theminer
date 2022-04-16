// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract Charity is ERC721, ERC721Enumerable, ERC721URIStorage {

    using SafeMath for uint256;

    uint public constant mintPrice = 5*10**16;
    address payable private _owner;
    mapping(string => address payable) charities;

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns(bool) {
        return super.supportsInterface(interfaceId);
    }

    constructor(address payable char1, address payable char2) ERC721("Bojack Charity", "BJC") {
        _owner = payable(msg.sender);
        charities["charity1"] = char1;
        charities["charity2"] = char2;
    }

    modifier onlyOwner {
        require(msg.sender == _owner, "You are not the owner.");
        _;
    }

    function addCharity(string memory name, address payable newChar) public onlyOwner {
        require(charities[name]==address(0), "Charity with name already exists.");
        charities[name] = newChar;
    }

    function withdraw() public onlyOwner {
        uint amount = address(this).balance;
  
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw Matic");
    }

    function mint(string memory _uri, string memory charity) public payable {
        require(msg.value >= mintPrice, "Not enough matic paid.");
        require(charities[charity]!= address(0), "No such charity.");
        (bool success, ) = charities[charity].call{value: 4*10*16}("");
        require(success, "Matic not transferred.");
        uint256 mintIndex = totalSupply();
        _safeMint(msg.sender, mintIndex);
        _setTokenURI(mintIndex, _uri);
    }

}
