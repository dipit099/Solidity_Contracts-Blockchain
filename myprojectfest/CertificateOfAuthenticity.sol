// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CertificateOfAuthenticity is ERC721URIStorage, Ownable {
    struct Certificate {
        uint256 artworkId;
        address owner;
        bool isVerified;
    }

    mapping(uint256 => Certificate) public certificates;
    uint256 public certificateCount;

    event CertificateIssued(uint256 certificateId, uint256 artworkId, address indexed owner);
    event CertificateVerified(uint256 certificateId, bool isVerified);

    constructor() ERC721("HelloNft", "HNFT") {}

    function issueCertificate(uint256 _artworkId, address _owner, string memory tokenURI)
        public onlyOwner returns (uint256)
    {
        certificateCount++;
        uint256 newCertificateId = certificateCount;

        _mint(_owner, newCertificateId);
        _setTokenURI(newCertificateId, tokenURI);
        certificates[newCertificateId] = Certificate({
            artworkId: _artworkId,
            owner: _owner,
            isVerified: false
        });

        emit CertificateIssued(newCertificateId, _artworkId, _owner);
        return newCertificateId;
    }

    function verifyCertificate(uint256 _certificateId) public onlyOwner {
        require(_exists(_certificateId), "Certificate does not exist");
        certificates[_certificateId].isVerified = true;
        emit CertificateVerified(_certificateId, true);
    }

    function isCertificateVerified(uint256 _certificateId) public view returns (bool) {
        require(ownerOf(_certificateId) != address(0), "Certificate does not exist");
        return certificates[_certificateId].isVerified;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override {
        require(from == address(0) || to == address(0), "Certificate cannot be transferred");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return ownerOf(tokenId) != address(0);
    }

}