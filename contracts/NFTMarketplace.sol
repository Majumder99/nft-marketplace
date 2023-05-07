// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract NFTMarketplace is ERC721URIStorage{
    address payable owner;
    uint256 public totalSupply = 1000;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    Counters.Counter private _itemsSold;

    uint256 listPrice = 0.01 ether;

    constructor() ERC721("Sourav", "SM"){
        owner = payable(msg.sender);
    }

    struct ListsToken{
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }

    mapping(uint256 => ListsToken) private listedTokens;

    function updateListPrice(uint256 _listPrice) public payable{
        require(owner == msg.sender, "Only owner can update the listing price");
        listPrice = _listPrice;
    }

    function getListPrice() public view returns(uint256){
        return listPrice;
    }

    function getLatestIdListedToken() public view returns(ListsToken memory){
        uint256 currentToken = _tokenId.current();
        return listedTokens[currentToken];
    }

    function getListedToken(uint256 tokenId) public view returns(ListsToken memory){
        return listedTokens[tokenId];
    }

    function getCurrentToken() public view returns(uint256){
        return _tokenId.current();
    }

    function createToken(string memory tokenURI, uint256 price) public payable returns (uint){
        _tokenId.increment();
        uint256 currentToken = _tokenId.current();
        require(price >= listPrice, "Price should be equal or larget than 0.05");
        require(currentToken <= totalSupply, "Total supply is extended");

        _safeMint(msg.sender, currentToken);
        _setTokenURI(currentToken, tokenURI);
        setListedToken(currentToken, price);
        return currentToken;
    }

    function setListedToken(uint256 tokenId, uint256 price) public {
        listedTokens[tokenId] = ListsToken(
            tokenId, 
            payable(address(this)),
            payable(msg.sender), 
            price,
            true
        );
        // I am sending my token to the contract address 
        _transfer(msg.sender, address(this), tokenId);
    }
}
