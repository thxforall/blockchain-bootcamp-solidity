// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
- 81 ~ 90 (1월 22일 23:59:59)
    1. Contract에 예치, 인출할 수 있는 기능을 구현하세요. 지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.  
    - 답안
    1. 특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
    - 답안
    1. 이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요. 사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
    - 답안
    1. 2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
    - 답안
    1. 숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
    - 답안
    1.  숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
    - 답안
    1. visibility에 신경써서 구현하세요. 
        
        숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 변화시키는 것도 오직 내부에서만 할 수 있게 해주세요. 
        
    - 답안
    1. 아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요.
        
        ```solidity
        contract OWNER {
        	address private owner;
        
        	constructor() {
        		owner = msg.sender;
        	}
        
            function setInternal(address _a) internal {
                owner = _a;
            }
        
            function getOwner() public view returns(address) {
                return owner;
            }
        }
        ```
        
        힌트 : 상속
        
    - 답안
        
        ```solidity
        
        ```
        
    1. 이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
    - 답안
        
        ```solidity
        
        ```
        
    1. 당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
    - 답안
        
        ```solidity
        
        ```

*/

contract Q81 {
    // 81. Contract에 예치, 인출할 수 있는 기능을 구현하세요. 지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.
    address public owner;
    mapping(address => uint256) public bank;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        bank[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(bank[msg.sender] > 0, "No deposit found");
        payable(owner).transfer(address(this).balance);
    }

    function getDeposit(address _address) public view returns (uint256) {
        return bank[_address];
    }
}
contract Q82 {
    // 82. 특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
    function countMultiples(
        uint256 _number
    ) public pure returns (uint256, uint256, uint256) {
        uint256 count3 = 0;
        uint256 count5 = 0;
        uint256 count8 = 0;
        for (uint256 i = 1; i <= _number; i++) {
            if (i % 3 == 0) {
                count3++;
            }
            if (i % 5 == 0) {
                count5++;
            }
            if (i % 8 == 0) {
                count8++;
            }
        }
        return (count3, count5, count8);
    }
}
contract Q83 {
    // 83. 이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요. 사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
    struct Person {
        string name;
        uint256 number;
        address wallet;
        string text;
    }
    Person[] public people;

    function pushPerson(Person memory _person) public {
        people.push(_person);
    }
}
contract Q84 {
    // 84. 2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 단, blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
    address public owner;
    mapping(address => bool) public blacklist;

    constructor() {
        owner = msg.sender;
    }

    function addToBlacklist(address _address) public {
        blacklist[_address] = true;
    }

    modifier checkBlacklist() {
        require(!blacklist[msg.sender], "Blacklisted");
        _;
    }

    function add(
        uint256 a,
        uint256 b
    ) public view checkBlacklist returns (uint256) {
        return a + b;
    }

    function sub(
        uint256 a,
        uint256 b
    ) public view checkBlacklist returns (uint256) {
        require(a > b, "Subtraction result cannot be negative");
        return a - b;
    }

    function mul(
        uint256 a,
        uint256 b
    ) public view checkBlacklist returns (uint256) {
        return a * b;
    }
}
contract Q85 {
    // 85. 숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
    uint256 public approve;
    uint256 public reject;

    uint256 public startBlock;
    uint256 public endBlock;

    constructor() {
        startBlock = block.number;
        endBlock = block.number + 20;
    }

    function voteApprove() public {
        require(
            block.number >= startBlock && block.number <= endBlock,
            "Voting period ended"
        );
        approve++;
    }

    function voteReject() public {
        require(
            block.number >= startBlock && block.number <= endBlock,
            "Voting period ended"
        );
        reject++;
    }
}
contract Q86 {
    // 86. 숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
    uint256 public approve;
    uint256 public reject;
    address public owner;

    mapping(address => bool) public blacklist;
    mapping(address => uint256) public deposits;

    constructor() {
        owner = msg.sender;
    }

    modifier checkBlacklist() {
        require(!blacklist[msg.sender], "Blacklisted");
        _;
    }

    modifier checkDeposit() {
        require(deposits[msg.sender] >= 1 ether, "Minimum deposit is 1 ether");
        _;
    }

    function addBlacklist(address _address) public {
        blacklist[_address] = true;
    }

    function deposit() public payable checkBlacklist checkDeposit {
        deposits[msg.sender] += msg.value;
    }

    function voteApprove() public checkBlacklist checkDeposit {
        approve++;
    }

    function voteReject() public checkBlacklist checkDeposit {
        reject++;
    }
}
contract Q87 {
    // 87. visibility에 신경써서 구현하세요.
    // 숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 변화시키는 것도 오직 내부에서만 할 수 있게 해주세요.
    uint256 private a;

    function setA(uint256 _a) internal {
        a = _a;
    }
}

contract OWNER {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function setInternal(address _a) internal {
        owner = _a;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}

contract Q88 is OWNER {
    // 88. 아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요.
    // 힌트 : 상속
    function setOwner(address _a) public {
        setInternal(_a);
    }
}
contract Q89 {
    // 89. 이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
    struct Customer {
        string name;
        string introduction;
    }

    Customer[] public customers;

    function addCustomer(
        string memory _name,
        string memory _introduction
    ) public {
        require(
            bytes(_name).length >= 5 &&
                bytes(_name).length <= 10 &&
                bytes(_introduction).length >= 20 &&
                bytes(_introduction).length <= 50,
            "Invalid customer"
        );
        customers.push(Customer(_name, _introduction));
    }
}
contract Q90 {
    // 90. 당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
    function getWalletName() public view returns (string memory) {
        return string(abi.encodePacked(msg.sender));
    }
}
