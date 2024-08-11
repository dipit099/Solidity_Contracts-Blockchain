// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArtworkRegistry {
    struct Artwork {
        string title;
        string ipfsHash;
        address creator;
    }



    mapping(uint256 => Artwork) public artworks;
    uint256 public artworkCount;

    event ArtworkRegistered(uint256 artworkId, string title, string ipfsHash, address indexed creator);

    function registerArtwork(string memory _title, string memory _ipfsHash) public {
        artworkCount++;
        artworks[artworkCount] = Artwork(_title, _ipfsHash, msg.sender);
        emit ArtworkRegistered(artworkCount, _title, _ipfsHash, msg.sender);
    }

    function getArtwork(uint256 _artworkId) public view returns (string memory title, string memory ipfsHash, address creator) {
        Artwork memory artwork = artworks[_artworkId];
        return (artwork.title, artwork.ipfsHash, artwork.creator);
    }
}
