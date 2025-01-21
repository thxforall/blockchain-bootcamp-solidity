// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AToken is ERC20, Ownable {
    uint256 public constant INITIAL_PRICE = 0.001 ether;
    uint256 public constant FINAL_PRICE = 0.005 ether;
    uint256 public immutable saleStartTime;
    uint256 public constant PRICE_CHANGE_DURATION = 2 days;

    constructor() ERC20("AToken", "ATK") Ownable(msg.sender) {
        saleStartTime = block.timestamp;
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function getCurrentPrice() public view returns (uint256) {
        if (block.timestamp <= saleStartTime + PRICE_CHANGE_DURATION) {
            return INITIAL_PRICE;
        }
        return FINAL_PRICE;
    }

    function buyTokens() public payable {
        uint256 currentPrice = getCurrentPrice();
        require(msg.value >= currentPrice, "Insufficient payment");
        
        uint256 tokenAmount = msg.value / currentPrice;
        _mint(msg.sender, tokenAmount);
        
        // Return excess ETH if any
        uint256 excess = msg.value - (tokenAmount * currentPrice);
        if (excess > 0) {
            payable(msg.sender).transfer(excess);
        }
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner()).transfer(balance);
    }
} 