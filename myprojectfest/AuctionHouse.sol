// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ArtworkRegistry.sol";

contract AuctionHouse {
    struct Bid {
        address bidder;
        uint256 amount;
    }

    mapping(uint256 => Bid[]) public bids;
    ArtworkRegistry public artworkRegistry;

    constructor(address _artworkRegistry) {
        artworkRegistry = ArtworkRegistry(_artworkRegistry);
    }

    function placeBid(uint256 _artworkId) public payable {
        require(msg.value > 0, "Bid amount should be greater than 0");
        bids[_artworkId].push(Bid(msg.sender, msg.value));
    }

    function getBids(uint256 _artworkId) public view returns (Bid[] memory) {
        return bids[_artworkId];
    }
}
