// SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract HelloNft is ERC721 {
    uint256 private tokenId;  // Token ID counter

    struct OwnershipRecord {
        address owner;
        uint nftId;
        string certificateUrl;
    }
    mapping(uint256 => OwnershipRecord[]) public ownershipRecords;  // Mapping of tokenId to ownership records
    mapping(uint256 => string) public _tokenURIs;  // Mapping for token URIs

    constructor() ERC721("HelloNft", "HNFT") {
        tokenId = 1;  // Start tokenId from 1
    }

    // no built in setTokenUri ..thats why custom function
    function _setTokenURI(uint256 _tokenId, string memory _tokenURI) internal virtual {
        require(ownerOf(_tokenId) != address(0), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[_tokenId] = _tokenURI;
    }

    function mintToken(address recipient, string memory tokenURI) public {
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);

        // Add the ownership record
        OwnershipRecord memory newRecord = OwnershipRecord({
            owner: recipient,
            nftId : tokenId,
            certificateUrl: tokenURI
        });
        ownershipRecords[tokenId].push(newRecord);

        tokenId = tokenId + 1;  // Increment the tokenId
    }

    // Function to get the token URI
    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(ownerOf(_tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[_tokenId];
    }
}



//In Ethereum, address(0) is a special address that represents an uninitialized or non-existent address. It is commonly used as a sentinel value to indicate "no address" or "address not set".
//5.x release notes states that: The _exists function was removed. 
//Calls to this function can be replaced by _ownerOf(tokenId) != address(0)


//i tried to transfer a nft from one owner to another . 
//only the owner of that nft can transfer that. so nice

// balanceOf: Returns the number of tokens owned by a specific address.
// ownerOf: Returns the owner of a specific token.
// transferFrom: Transfers ownership of a token from one address to another.
// approve: Approves another address to transfer a specific token.
// getApproved: Gets the approved address for a specific token.
// setApprovalForAll: Approves or removes approval for an operator to manage all tokens of the caller.
// isApprovedForAll: Checks if an operator is approved to manage all of the owner’s tokens.