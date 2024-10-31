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

    function updatePrice(uint _itemId, uint _newPrice) public {
        items[_itemId].price = _newPrice;
    }

    function getTotalInventoryValue() public view returns (uint) {
        uint totalValue = 0;
        for (uint i = 1; i <= itemCount; i++) {
            totalValue += items[i].price * items[i].stock;
        }
        return totalValue;
    }

    function deleteMultipleItems(uint[] memory _itemIds) public {
        for (uint i = 0; i < _itemIds.length; i++) {
            delete items[_itemIds[i]];
        }
    }

    function getItemsInRange(uint _startId, uint _endId) public view returns (Item[] memory) {
        require(_startId >= 1 && _endId <= itemCount, "Invalid range");
        require(_endId >= _startId, "End ID must be greater than start ID");

        Item[] memory itemRange = new Item[](_endId - _startId + 1);
        uint index = 0;

        for (uint i = _startId; i <= _endId; i++) {
            itemRange[index] = items[i];
            index++;
        }

        return itemRange;
    }
}
