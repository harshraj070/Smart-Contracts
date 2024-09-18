// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InventoryManagement {

    struct Item {
        string name;
        uint price;
        uint stock;
    }

    mapping(uint => Item) public items;
    uint public itemCount;

    function addItem(string memory _name, uint _price, uint _stock) public {
        itemCount++;
        items[itemCount] = Item(_name, _price, _stock);
    }

    function getItem(uint _itemId) public view returns (string memory, uint, uint) {
        Item memory item = items[_itemId];
        return (item.name, item.price, item.stock);
    }

    function updateStock(uint _itemId, uint _newStock) public {
        items[_itemId].stock = _newStock;
    }

    function deleteItem(uint _itemId) public {
        delete items[_itemId];
    }
}
