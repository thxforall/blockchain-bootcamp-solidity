// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


/*
- 61 ~ 70 (1월 20일 23:59:59)
    1. a의 b승을 반환하는 함수를 구현하세요.
    - 답안
    1. 2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
    - 답안
    1. 2개 숫자의 차를 나타내는 함수를 구현하세요.
    - 답안
    1. 지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
    - 답안
    1. 숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요. 그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
        
        예) func A : input → 1,2,3 // output → 1,4,9 | func B : output 4 (1,4,9중 가운데 숫자) 
        
    - 답안
    1. 특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
    - 답안
    1. 자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
        
        B의 함수를 이용하여 A에게 전송하고 A의 잔고 변화를 확인하세요.
        
    - 답안
    1. 계승(팩토리얼)을 구하는 함수를 구현하세요. 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다. 
        
        예) 5 → 1*2*3*4*5 = 60, 11 → 1*2*3*4*5*6*7*8*9*10*11 = 39916800
        
        while을 사용해보세요
        
    - 답안
    1. 숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
        
        힌트 : 7번 문제(시,분,초로 변환하기)
        
    - 답안
    1. 번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 고객의 정보를 넣고 변화시키는 함수를 구현하세요. 
    - 답안
 */

contract Q61 {
    // 61. a의 b승을 반환하는 함수를 구현하세요.
    function power(uint256 a, uint256 b) public pure returns (uint256) {
        return a ** b;
    }
}

contract Q62 {
    // 62. 2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.

    modifier lessThanTen(uint256 a, uint256 b) {
        require(a < 10 && b < 10, "Input values must be less than 10");
        _;
    }

    function add(uint256 a, uint256 b) public pure lessThanTen(a, b) returns (uint256) {
        return a + b;
    }

    function multiply(uint256 a, uint256 b) public pure lessThanTen(a, b) returns (uint256) {
        return a * b;
    }

    function power(uint256 a, uint256 b) public pure lessThanTen(a, b) returns (uint256) {
        return a ** b;
    }
}

contract Q63 {
    // 63. 2개 숫자의 차를 나타내는 함수를 구현하세요.
    function sub(uint256 a, uint256 b) public pure returns (uint256) {
        if (a < b) {
            return b - a;
        } else {
            return a - b;
        }
    }
}

contract Q64 { 
    // 64. 지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
    function splitAddress(address _addr) public pure returns (bytes4[] memory) {
        bytes4[] memory result = new bytes4[](5);
        bytes20 addr = bytes20(_addr);  
        
        for (uint256 i = 0; i < 5; i++) {
            bytes4 chunk;
            assembly {
                chunk := mload(add(addr, add(0x04, mul(i, 0x04))))
            }
            result[i] = chunk;
        }
        return result;
    }   
}

contract Q65 {
    // 65. 숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요. 그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
    function getMiddleSquare(uint256 a, uint256 b, uint256 c) public pure returns (uint256) {
        uint256[] memory squares = new uint256[](3);
        squares[0] = a ** 2;
        squares[1] = b ** 2;
        squares[2] = c ** 2;
        return squares[1];
    }

}

contract Q66 {
    // 66. 특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
    function getDigitCount(uint256 _n) public pure returns (uint256, uint256) {
        uint256 decimalCount = 0;
        uint256 fiveCount = 0;
        while (_n > 0) {
            decimalCount++;
            fiveCount += _n % 5;
            _n /= 5;
        }
        return (decimalCount, fiveCount);
    }
}

contract Q67 {
    // 67. 자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function sendMoney(address payable _to, uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can send money");
        _to.transfer(_amount);
    }
}

contract Q68 {
    // 68. 계승(팩토리얼)을 구하는 함수를 구현하세요.
    // 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다.
    // while을 사용해보세요
    function factorialWhile(uint256 _n) public pure returns (uint256) {
        uint256 result = 1;
        uint256 i = 1;
        while (i <= _n) {
            result *= i;
            i++;
        }
        return result;
    }
}

contract Q69 {
    // 69. 숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
    function getResult(uint256 a, uint256 b, uint256 c) public pure returns (string memory) {
        return string(abi.encodePacked(a, " and ", b, " or ", c));
    }
}

contract Q70 {
    // 70. 번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 고객의 정보를 넣고 변화시키는 함수를 구현하세요. 
    struct Customer {
        uint256 id;
        string name;
        bytes32 hashId;
    }

    Customer[] public customers;

    function addCustomer(uint256 _id, string memory _name) public {
        customers.push(Customer(_id, _name, keccak256(abi.encodePacked(_id, _name))));
    }   

    function getCustomer(uint256 _index) public view returns (Customer memory) {
        return customers[_index];
    }

    function updateCustomer(uint256 _index, string memory _name) public {
        customers[_index].name = _name;
        customers[_index].hashId = keccak256(abi.encodePacked(customers[_index].id, _name));
    }
}