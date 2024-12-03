// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    // Mapping to store item prices
    mapping(string => uint256) public itemPrices;

    constructor(address initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {
        // Set a sample item price
        itemPrices["Sword of Valor"] = 1000 * 10 ** decimals();
    }

    // Mint new tokens, only the owner can mint
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Set item price, only the owner can set prices
    function setItemPrice(string memory itemName, uint256 price) public onlyOwner {
        itemPrices[itemName] = price;
    }

    // Redeem tokens for in-game items
    function redeem(string memory itemName) public {
        uint256 price = itemPrices[itemName];
        require(price > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= price, "Insufficient balance");

        _burn(msg.sender, price);
        
    }

    // Burn tokens
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
