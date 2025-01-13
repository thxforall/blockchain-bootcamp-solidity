// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract APP {
    address public taxAuth;
    uint256 public taxBalance;

    struct Bank {
        string name;
        address bankAddr;
        uint256 totalBalance;
    }

    struct User {
        string name;
        address userAddr;
        uint256 balance;
        uint256 tax;
    }

    mapping(address => Bank) public banks;
    mapping(address => mapping(address => User)) public users;
    address[] public banksArr;
    address[] public usersArr;

    modifier verifyAuth() {
        require(msg.sender == taxAuth,"Can't Access");
        _;
    }

    constructor() {
        taxAuth = msg.sender;
    }

    function registerBank(string memory _name) public verifyAuth {
        BANK newBank = new BANK(_name, address(this));
        address _bankAddr = address(newBank);

        Bank memory newBankStruct = Bank({
            name : _name,
            bankAddr : _bankAddr,
            totalBalance : 0
        });

        banks[_bankAddr] = newBankStruct;
        banksArr.push(_bankAddr);
    }

    function collectTaxex() public verifyAuth {
        for(uint i = 0; i < banksArr.length; i++) {
            address _bankAddr = banksArr[i];
            for(uint j = 0; j < usersArr.length; j++) {
                address userAddr = usersArr[j];
                User storage user = users[_bankAddr][userAddr];

                uint256 taxAmount = user.balance / 100;
                user.tax += taxAmount;
            }
        }
    }

    function enforceTax(address _bankAddr, address _userAddr) public verifyAuth {
        User storage user = users[_bankAddr][_userAddr];
        require(user.tax > 0, "None Tax");

        Bank storage bank = banks[_bankAddr];
        require(bank.totalBalance >= user.tax, "None Balance");

        uint256 taxAmount = user.tax;
        user.tax = 0;
        bank.totalBalance -= taxAmount;
        taxBalance += taxAmount;
    }
}

contract BANK {
    string public name;
    address public owner;
    uint256 public totalBalance;

    struct User {
        string name;
        address userAddr;
        uint256 balance;
    }

    mapping(address => User) public users;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute");
        _;
    }

    constructor(string memory _name, address _owner) {
        name = _name;
        owner = _owner;
    }

    function registerUser(string memory _name) public {
        require(users[msg.sender].userAddr == address(0), "User already registered");
        users[msg.sender] = User({ name: _name, userAddr: msg.sender, balance: 0 });
    }

    function deposit() public payable {
        require(users[msg.sender].userAddr != address(0), "User not registered");
        users[msg.sender].balance += msg.value;
        totalBalance += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(users[msg.sender].balance >= _amount, "Insufficient balance");
        users[msg.sender].balance -= _amount;
        totalBalance -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}