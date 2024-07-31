// SPDX-License-Identifier: MIT
// Some compilers may show a warning if this is not used.

pragma solidity 0.8.24;

contract SimpleStorage {

    uint256 favoriteNumber;  //default = 0
    
    struct People {
        uint256 favoriteNumber;
        string name;
    }
    
    People public person = People(12, "dipit");
    People[] public manyPeople;  // Array to store multiple People

    // Mapping from a person's name to their favorite number
    mapping(string => uint256) public nameToFavoriteNumber;

    // View function: promise not to modify the state of the blockchain.
    // Pure function: are even more restrictive than view functions. They cannot read or modify any data from the blockchain. 
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve_number() public view returns (uint256) {
        return favoriteNumber;
    }
    
    // The "memory" keyword is needed for strings in function parameters to specify temporary storage in memory rather than contract storage.
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        manyPeople.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;  // Add to mapping
    }
}
