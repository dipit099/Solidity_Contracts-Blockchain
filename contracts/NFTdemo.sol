// SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Hellonft is ERC721("HelloNft", "HNFT") {
    uint tokenId;
    mapping(address=>tokenMetaData[]) public ownershipRecord;

    struct tokenMetaData {
        uint tokenId;
        uint timeStamp;
        string tokenURI;
    }

    function mintToken(address recipient, string memory url) public {
        _safeMint(recipient, tokenId);
        ownershipRecord[recipient].push(tokenMetaData(tokenId, block.timestamp, url));
        tokenId = tokenId + 1;
    }
}
//i tried to transfer a nft from one owner to another . only the owner of that nft can transfer that. so nice



// balanceOf: Returns the number of tokens owned by a specific address.
// ownerOf: Returns the owner of a specific token.
// transferFrom: Transfers ownership of a token from one address to another.
// approve: Approves another address to transfer a specific token.
// getApproved: Gets the approved address for a specific token.
// setApprovalForAll: Approves or removes approval for an operator to manage all tokens of the caller.
// isApprovedForAll: Checks if an operator is approved to manage all of the owner’s tokens.