// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LOTTO {
    address private owner;
    uint256 private constant TICKET_PRICE = 0.05 ether;
    uint256 private salt;

    mapping(address => uint256) public rewards;

    constructor() {
        owner = msg.sender;
        salt = uint256(keccak256(abi.encodePacked(block.number, msg.sender)));
    }

    function _generateRandomValue() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.prevrandao,
                        msg.sender,
                        salt
                    )
                )
            );
    }

    function _generateRandomNumber() internal view returns (uint8) {
        return uint8((_generateRandomValue() % 9) + 1); // 1~9
    }

    function _generateRandomLetter() internal view returns (bytes1) {
        return bytes1(uint8((_generateRandomValue() % 26) + 65)); // ASCII 65~90 ('A'~'Z')
    }

    function play(uint8[4] memory userNumbers, bytes1[2] memory userLetters)
        public
        payable
    {
        require(msg.value == TICKET_PRICE, "Ticket price is 0.05 ether");

        uint8[4] memory winningNumbers = _generateWinningNumbers();
        bytes1[2] memory winningLetters = _generateWinningLetters();

        uint256 matches = _countMatches(userNumbers, userLetters, winningNumbers, winningLetters);

        uint256 reward = _calculateReward(matches);
        if (reward > 0) {
            rewards[msg.sender] += reward;
        }
    }

    function _generateWinningNumbers() internal view returns (uint8[4] memory) {
        return [
            _generateRandomNumber(),
            _generateRandomNumber(),
            _generateRandomNumber(),
            _generateRandomNumber()
        ];
    }

    function _generateWinningLetters() internal view returns (bytes1[2] memory) {
        return [
            _generateRandomLetter(),
            _generateRandomLetter()
        ];
    }

    function _countMatches(
        uint8[4] memory userNumbers,
        bytes1[2] memory userLetters,
        uint8[4] memory winningNumbers,
        bytes1[2] memory winningLetters
    ) internal pure returns (uint256) {
        uint256 matchCount = 0;

        matchCount += _countArrayMatches(userNumbers, winningNumbers);

        matchCount += _countArrayMatches(userLetters, winningLetters);

        return matchCount;
    }

    function _countArrayMatches(bytes1[2] memory arr1, bytes1[2] memory arr2)
        internal
        pure
        returns (uint256)
    {
        uint256 matchCount = 0;
        for (uint256 i = 0; i < arr1.length; i++) {
            for (uint256 j = 0; j < arr2.length; j++) {
                if (arr1[i] == arr2[j]) {
                    matchCount++;
                    break;
                }
            }
        }
        return matchCount;
    }

    function _countArrayMatches(uint8[4] memory arr1, uint8[4] memory arr2)
        internal
        pure
        returns (uint256)
    {
        uint256 matchCount = 0;
        for (uint256 i = 0; i < arr1.length; i++) {
            for (uint256 j = 0; j < arr2.length; j++) {
                if (arr1[i] == arr2[j]) {
                    matchCount++;
                    break;
                }
            }
        }
        return matchCount;
    }

    function _calculateReward(uint256 matches) internal pure returns (uint256) {
        if (matches == 6) return 1 ether;
        if (matches == 5) return 0.75 ether;
        if (matches == 4) return 0.25 ether;
        if (matches == 3) return 0.1 ether;
        return 0;
    }

    function getReward() public {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No reward to get");

        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
    }
}