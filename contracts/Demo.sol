// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Import the ERC721 standard from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Define your contract and inherit from ERC721
contract Certificate is ERC721 {
    struct CertificateData {
        uint256 artworkId;
        address creator;
        uint256 issueDate;
    }

    // Mapping to store certificate data
    mapping(uint256 => CertificateData) public certificates;

    // Constructor to initialize the ERC721 token
    constructor() ERC721("Certificate", "CERT") {}

    // Function to get certificate data
    function getCertificateData(uint256 tokenId)
        public
        view
        returns (
            uint256,
            address,
            uint256
        )
    {
        require(_exists(tokenId), "Certificate: Token ID does not exist");

        CertificateData memory data = certificates[tokenId];
        return (data.artworkId, data.creator, data.issueDate);
    }

    // Additional functions to mint and manage certificates can go here
}
