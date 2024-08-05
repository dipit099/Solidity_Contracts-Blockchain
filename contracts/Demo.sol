// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Artwork {
    // Artwork struct
    struct Art {
        address owner;
        string image;
        string description;
        uint256 price;
        string credentials;
        uint256 quantity;
        bool isVerified;
        string tokenUri;
        address original_artist;
    }

    // Purchase struct
    struct Purchase {
        uint256 id;
        uint256 artId;
        address buyer;
        address seller;
        uint256 amount;
        uint256 total_amount;
        uint256 amounts_paid;
        uint256 amounts_remaining;
        string delivery_state;
        bool delivered_status;

    }
    
    uint256 art_count;
    
    uint256 purchase_count;

    mapping(uint256 => Art) public artworks;
    mapping(uint256 => Purchase) public purchases;
    
    event ArtWorkCreated(address artist,uint256 price, uint256 artId);

    // Create Artwork
    function createArt(
        address _owner,
        string memory _image_path,
        string memory _description,
        uint256 _price,
        string memory _credentials,
        uint256 _quantity
    ) public {
        Art storage art = artworks[art_count];
        art.owner = _owner;
        art.image = _image_path;
        art.description = _description;
        art.price = _price;
        art.credentials = _credentials;
        art.quantity = _quantity;
        art.isVerified = false;
        art.tokenUri = "";
        art.original_artist = _owner;
        art_count++;
        emit ArtWorkCreated(_owner, _price, art_count);
    }
    // Get All Artworks
    function getArtworks() public view returns (Art[] memory) {
        Art[] memory allArtworks = new Art[](art_count);

        for (uint i = 0; i < art_count; i++) {
            Art storage item = artworks[i];

            allArtworks[i] = item;
        }

        return allArtworks;
    }

     // Purchase Event
    event ArtworkPurchased(uint256 artId, 
    address indexed buyer, 
    address indexed seller, 
    uint256 amount,
    uint256 totalAmount);
    
    // Purchase Artwork and add order to purchases
    function buyArtwork(uint256 art_id) public payable {
        Art storage art = artworks[art_id];

        require(art.quantity > 0, "Artwork is out of stock");
        require(msg.sender != art.owner, "Owner cannot buy their own artwork");
        uint256 amount = art.price;

        require(msg.value == amount, "Incorrect payment amount");

        (bool sent, ) = art.owner.call{value: amount}("");
        require(sent, "Payment failed");

        art.quantity--;

        purchases[purchase_count] = Purchase({
            id: purchase_count,
            artId: art_id,
            buyer: msg.sender,
            seller: art.owner,
            amount: amount,
            total_amount: art.price,
            amounts_paid: amount,
            amounts_remaining: art.price - amount,
            delivery_state: "in warehouse",
            delivered_status: false
        });

        purchase_count++;

        emit ArtworkPurchased(art_id, msg.sender, art.owner, amount, msg.value);
    }


   
}
