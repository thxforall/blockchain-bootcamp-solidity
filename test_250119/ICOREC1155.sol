// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ICOERC1155 is ERC1155, Ownable {
    uint256 public constant TIER1 = 1;
    uint256 public constant TIER2 = 2;
    uint256 public constant TIER3 = 3;
    uint256 public constant TIER4 = 4;

    uint256 public tier1Price = 0.01 ether;
    uint256 public tier2Price = 0.05 ether;
    uint256 public tier3Price = 0.1 ether;
    uint256 public tier4Price = 0.2 ether;

    uint256 public constant MAX_SUPPLY_TIER1 = 1000;
    uint256 public constant MAX_SUPPLY_TIER2 = 500;
    uint256 public constant MAX_SUPPLY_TIER3 = 200;
    uint256 public constant MAX_SUPPLY_TIER4 = 100;

    mapping(uint256 => uint256) public totalSold;
    uint256 public icoEndBlock;

    constructor()
        ERC1155("https://example.com/metadata/{id}.json")
        Ownable(msg.sender)
    {
        icoEndBlock = block.number + 50;
    }

    function buyTokens(uint256 tier, uint256 amount) external payable {
        require(block.number <= icoEndBlock, "ICO has ended");
        require(tier >= TIER1 && tier <= TIER4, "Invalid tier");

        uint256 price = getTierPrice(tier);
        uint256 cost = price * amount;
        require(msg.value >= cost, "Insufficient funds");
        require(
            totalSold[tier] + amount <= getMaxSupply(tier),
            "Exceeds max supply"
        );

        _mint(msg.sender, tier, amount, "");
        totalSold[tier] += amount;

        if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
        }
    }

    function getTierPrice(uint256 tier) public view returns (uint256) {
        if (tier == TIER1) return tier1Price;
        if (tier == TIER2) return tier2Price;
        if (tier == TIER3) return tier3Price;
        if (tier == TIER4) return tier4Price;
        revert("Invalid tier");
    }

    function getMaxSupply(uint256 tier) public pure returns (uint256) {
        if (tier == TIER1) return MAX_SUPPLY_TIER1;
        if (tier == TIER2) return MAX_SUPPLY_TIER2;
        if (tier == TIER3) return MAX_SUPPLY_TIER3;
        if (tier == TIER4) return MAX_SUPPLY_TIER4;
        revert("Invalid tier");
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }
}
