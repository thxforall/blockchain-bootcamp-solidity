// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// A라고 하는 erc-20(decimal 0)을 발행하고, B라는 NFT를 발행하십시오.
// A 토큰은 개당 0.001eth 정가로 판매한다.
// B NFT는 오직 A로만 구매할 수 있고 가격은 50으로 시작합니다.
// 첫 10명은 50A, 그 다음 20명은 100A, 그 다음 40명은 200A로 가격이 상승합니다. (추가는 안해도 됨)

// B를 burn 하면 20 A만큼 환불 받을 수 있고, 만약에 C라고 하는 contract에 전송하면 30A 만큼 받는 기능도 구현하세요.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC20APP is ERC20 {
    uint256 public constant TOKEN_PRICE = 0.001 ether;

    constructor() ERC20("TokenA", "A") {
        _mint(msg.sender, 0);
    }

    function buyToken(uint256 _amount) public payable {
        require(msg.value == _amount * TOKEN_PRICE, "Incorrect Ether value");
        _mint(msg.sender, _amount);
    }
}

contract ERC721APP is ERC721 {
    ERC20APP public tokenA;
    uint256 public nextTokenId = 0;
    uint256 public constant NFT_PRICE = 50;
    address public refundContract;

    constructor(address _tokenAddress, address _refundContract)
        ERC721("NFTB", "B")
    {
        tokenA = ERC20APP(_tokenAddress);
        refundContract = _refundContract;
    }

    function getPrice() public view returns (uint256) {
        if (nextTokenId < 10) {
            return 50;
        } else if (nextTokenId < 30) {
            return 100;
        } else if (nextTokenId < 70) {
            return 200;
        } else {
            revert("Too Expensive");
        }
    }

    function buyNFT() public {
        uint256 _price = getPrice();
        require(tokenA.balanceOf(msg.sender) >= _price, "Not Enough Ether");
        tokenA.transferFrom(msg.sender, address(this), _price);
        _mint(msg.sender, nextTokenId);
        nextTokenId++;
    }

    function burnNFT(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner");
        _burn(tokenId);
        tokenA.transfer(msg.sender, 20);
    }

    function transferToContract(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner");
        require(
            msg.sender == refundContract,
            "Can only transfer to refundContract"
        );
        _burn(tokenId);
        tokenA.transfer(msg.sender, 30);
    }
}
