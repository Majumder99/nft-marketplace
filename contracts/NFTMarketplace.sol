// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

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

     //This will return all the NFTs currently listed to be sold on the marketplace
    function getAllNFTs() public view returns (ListsToken[] memory) {
        uint nftCount = _tokenId.current();
        ListsToken[] memory tokens = new ListsToken[](nftCount);
        uint currentIndex = 0;
        uint currentId;
        //at the moment currentlyListed is true for all, if it becomes false in the future we will 
        //filter out currentlyListed == false over here
        for(uint i=0;i<nftCount;i++)
        {
            currentId = i + 1;
            ListsToken storage currentItem = listedTokens[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }
        //the array 'tokens' has the list of all NFTs in the marketplace
        return tokens;
    }
    
    //Returns all the NFTs that the current user is owner or seller in
    function getMyNFTs() public view returns (ListsToken[] memory) {
        uint totalItemCount = _tokenId.current();
        uint itemCount = 0;
        uint currentIndex = 0;
        uint currentId;
        //Important to get a count of all the NFTs that belong to the user before we can make an array for them
        for(uint i=0; i < totalItemCount; i++)
        {
            if(listedTokens[i+1].owner == msg.sender || listedTokens[i+1].seller == msg.sender){
                itemCount += 1;
            }
        }

        //Once you have the count of relevant NFTs, create an array then store all the NFTs in it
        ListsToken[] memory items = new ListsToken[](itemCount);
        for(uint i=0; i < totalItemCount; i++) {
            if(listedTokens[i+1].owner == msg.sender || listedTokens[i+1].seller == msg.sender) {
                currentId = i+1;
                ListsToken storage currentItem = listedTokens[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function executeSale(uint256 tokenId) public payable {
        uint price = listedTokens[tokenId].price;
        address seller = listedTokens[tokenId].seller;
        require(msg.value == price, "Please submit the asking price in order to complete the purchase");

        //update the details of the token
        listedTokens[tokenId].currentlyListed = true;
        listedTokens[tokenId].seller = payable(msg.sender);
        _itemsSold.increment();

        //Actually transfer the token to the new owner
        _transfer(address(this), msg.sender, tokenId);
        //approve the marketplace to sell NFTs on your behalf
        approve(address(this), tokenId);

        //Transfer the listing fee to the marketplace creator
        payable(owner).transfer(listPrice);
        //Transfer the proceeds from the sale to the seller of the NFT
        payable(seller).transfer(msg.value);
    }

    function setListItem(uint256 tokenId) public {
        listedTokens[tokenId].currentlyListed = true;
    }
}
