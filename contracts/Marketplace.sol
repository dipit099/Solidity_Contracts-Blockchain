// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Marketplace {
    struct Item {
        uint id;
        address payable seller;
        string name;
        uint price;
        bool sold;
    }

    uint public itemCount = 0;
    mapping(uint => Item) public items;

    event ItemListed(uint id, address seller, string name, uint price);
    event ItemPurchased(uint id, address buyer, address seller, uint price);

    function listItem(string memory _name, uint _price) public {
        require(_price > 0, "Price must be greater than zero");

        itemCount++;
        items[itemCount] = Item(itemCount, payable(msg.sender), _name, _price, false);

        emit ItemListed(itemCount, msg.sender, _name, _price);
    }

    function purchaseItem(uint _id) public payable {
        Item storage item = items[_id];
        require(_id > 0 && _id <= itemCount, "Item does not exist");
        require(msg.value == item.price, "Incorrect value sent");
        require(!item.sold, "Item already sold");
        require(item.seller != msg.sender, "Seller cannot buy their own item");

        item.seller.transfer(msg.value);
        item.sold = true;

        emit ItemPurchased(_id, msg.sender, item.seller, item.price);
    }
}
