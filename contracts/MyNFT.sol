// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ArtMarketplace is ERC721, Ownable {
    constructor(address initialOwner)
        ERC721("MyNFT", "MTK")
        Ownable(initialOwner)
    {}

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Art {
        uint256 id;
        string name;
        string tokenURI;
        address payable creator;
        address payable owner;
        uint256 price;
        bool isForSale;
        uint256 timestamp; 
    }

    mapping(uint256 => Art) public arts;
    mapping(uint256 => string) public _tokenURIs; 

    event ArtCreated(uint256 id, string name, string tokenURI, address creator, uint256 price);
    event ArtSold(uint256 id, address buyer, uint256 price);

   
     function _setTokenURI(uint256 _tokenId, string memory _tokenURI) internal virtual {
        require(ownerOf(_tokenId) != address(0), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[_tokenId] = _tokenURI;
    }

    function createArt(string memory name, string memory tokenURI, uint256 price) public returns (uint256) {
        _tokenIds.increment(); //so starting from 1
        uint256 newArtId = _tokenIds.current();

        _mint(msg.sender, newArtId);
        _setTokenURI(newArtId, tokenURI);

        arts[newArtId] = Art({
            id: newArtId,
            name: name,
            tokenURI: tokenURI,
            creator: payable(msg.sender),
            owner: payable(msg.sender),
            price: price,
            isForSale: true,
            timestamp: block.timestamp 
        });

        emit ArtCreated(newArtId, name, tokenURI, msg.sender, price);

        return newArtId;
    }

    function buyArt(uint256 artId) public payable {
        Art memory art = arts[artId];
        require(msg.sender != art.creator, "Creator cannot buy their own art");
        require(msg.value >= art.price, "Insufficient funds to buy this art");
        require(art.isForSale, "This art is not for sale");

        address payable seller = art.owner;

        // Transfer ownership
        art.owner = payable(msg.sender);
        art.isForSale = false;
        arts[artId] = art;

        _transfer(seller, msg.sender, artId);

        // Pay the seller
        seller.transfer(msg.value);

        emit ArtSold(artId, msg.sender, art.price);
    }

    function setForSale(uint256 artId, uint256 price) public {
        require(msg.sender == arts[artId].owner, "Only the owner can put the art for sale");
        arts[artId].isForSale = true;
        arts[artId].price = price;
    }

    function getArtWorks() public view returns (Art[] memory) {
        uint256 totalArtworks = _tokenIds.current();
        Art[] memory allArts = new Art[](totalArtworks); //just created obj array

        for (uint256 i = 0; i < totalArtworks; i++) {
            allArts[i] = arts[i + 1];
        }

        return allArts;
    }
}
