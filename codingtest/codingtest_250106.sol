// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Game {
    struct User {
        uint256 number;
        string name;
        address addr;
        uint256 balance;
        uint256 score;
    }

    User[] public users;
    User[4] private gameRoom;

    uint256 private userNum = 1;
    uint256 private roomCount = 0;
    uint256 private constant ENTRY_FEE = 0.01 ether;

    address private admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerUser(string memory _name) external {
        for (uint256 i = 0; i < users.length; i++) {
            require(
                keccak256(abi.encodePacked(users[i].name)) !=
                    keccak256(abi.encodePacked(_name)),
                "Already in use"
            );
        }
        users.push(
            User({
                number: userNum,
                name: _name,
                addr: msg.sender,
                balance: 0,
                score: 0
            })
        );

        userNum++;
    }

    function getUserByName(string memory _name)
        public
        view
        returns (User memory)
    {
        for (uint256 i = 0; i < users.length; i++) {
            if (
                keccak256(abi.encodePacked(users[i].name)) ==
                keccak256(abi.encodePacked(_name))
            ) {
                return users[i];
            }
        }
        revert("User not found");
    }

    function depositFunds(string memory _name) external payable {
        User memory user = getUserByName(_name);

        for (uint256 i = 0; i < users.length; i++) {
            if (users[i].addr == user.addr) {
                users[i].balance += msg.value;
                break;
            }
        }
    }

    function joinGameWithDeposit(string memory _name) external {
        User memory user = getUserByName(_name);

        for (uint256 i = 0; i < users.length; i++) {
            if (users[i].addr == user.addr) {
                require(users[i].balance >= ENTRY_FEE, "Not enough deposit");
                users[i].balance -= ENTRY_FEE;
                gameRoom[roomCount] = users[i];
                roomCount++;
                break;
            }
        }

        if (roomCount == 4) {
            assignScores();
            resetGameRoom();
        }
    }

    function assignScores() private {
        uint256[4] memory scores = [
            uint256(4),
            uint256(3),
            uint256(2),
            uint256(1)
        ];
        for (uint256 i = 0; i < 4; i++) {
            for (uint256 j = 0; j < users.length; j++) {
                if (users[j].addr == gameRoom[i].addr) {
                    users[j].score += scores[i];
                    break;
                }
            }
        }
    }

    function resetGameRoom() private {
        for (uint256 i = 0; i < 4; i++) {
            delete gameRoom[i];
        }
        roomCount = 0;
    }

    function getRoomStatus() external view returns (User[4] memory) {
        return gameRoom;
    }

    function withdraw(uint256 amount) external onlyAdmin {
        require(
            address(this).balance >= amount,
            "Contract has insufficient funds"
        );
        payable(admin).transfer(amount);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function convertScoreToEth(string memory _name) external {
        User memory user = getUserByName(_name);

        uint256 ethAmount = (user.score / 10) * 0.1 ether;
        require(ethAmount > 0, "Not enough score to convert");
        require(
            address(this).balance >= ethAmount,
            "Contract has insufficient funds"
        );

        uint256 userDeductSore = (user.score / 10) * 10;

        for (uint256 i = 0; i < users.length; i++) {
            if (users[i].addr == user.addr) {
                users[i].score -= userDeductSore;
                break;
            }
        }

        payable(user.addr).transfer(ethAmount);
    }
}
