// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*

- 71 ~ 80 (1월 19일 23:59:59)
    1. 숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
    한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
    - 답안
    1.  contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요. owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
        
        예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner)
        
    - 답안
    1. 위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
        
        예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(E가 owner, E 누적 65), E가 65 deposit(E)
        
    - 답안
    1. 어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
        
        예) 20 -> 22(20 + 2, 2는 20의 10%), 0 // 50 -> 55(50+5, 5는 50의 10%), 0 // 42 -> 46(42+4), 4 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) // 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
        
    - 답안
    1. 문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
        
        예) abc,3 -> abcabcabc // ab,5 -> ababababab
        
    - 답안
    1. 숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. 
    (패키지없이)
    - 답안
    1. 위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
        
        힌트 : import "@openzeppelin/contracts/utils/Strings.sol";
        
    - 답안
    1. 숫자만 들어갈 수 있는 array를 선언하세요. array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
        
        예) [1,2,6,9,11,19] -> true (19는 10~25 사이) // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
        
    - 답안
    1. 3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요. Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요. 학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요. 구현할 때는 Contract A를 import 하여 구현하세요.
    - 답안
    1. 지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 가장 먼저 들어온 것이 가장 마지막에 나갑니다. 이런 것들을FILO(First In Last Out)이라고도 합니다. 가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다. push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
    - 답안

*/

contract Q71 {
    // 71. 숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요. 한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
    uint256 public a;
    uint256 public lastChangeTime;

    function setA(uint256 _a) public {
        require(block.timestamp >= lastChangeTime + 10 minutes, "Cannot change for 10 minutes");
        a = _a;
        lastChangeTime = block.timestamp;
    }   

    function getA() public view returns (uint256) {
        return a;
    }
}

contract Q72 {
    // 72. contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 
    // 해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요.
    // owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
    // 예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner, E 누적 65), E가 65 deposit(E)
    address public owner;
    uint256 public maxDeposit;
    mapping(address => uint256) public totalDeposits;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        totalDeposits[msg.sender] += msg.value;
        
        if(totalDeposits[msg.sender] > maxDeposit) {
            maxDeposit = totalDeposits[msg.sender];
            owner = msg.sender;
        }
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getUserTotalDeposit(address user) public view returns (uint256) {
        return totalDeposits[user];
    }
}

contract Q73 {
    // 73. 1. 위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
    //예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(E가 owner, E 누적 65), E가 65 deposit(E)
    address public owner;
    mapping(address => uint256) public deposits;
    uint256 public maxTotalDeposit;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        deposits[msg.sender] += msg.value;
        
        if(deposits[msg.sender] > maxTotalDeposit) {
            maxTotalDeposit = deposits[msg.sender];
            owner = msg.sender;
        }
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}

contract Q74 {
    // 74. 어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
    // 예) 20 -> 22(20 + 2, 2는 20의 10%), 0 // 50 -> 55(50+5, 5는 50의 10%), 0 // 42 -> 46(42+4), 4 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) // 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 2를 분리해서 반환)
    function addTenPercent(uint256 _number) public pure returns (uint256, uint256) {
        uint256 tenPercent = _number * 10 / 100;
        uint256 total = _number + tenPercent;
        uint256 decimal = ((_number * 10 / 100) * 10) % 10;
        return (total, decimal);
    }
}

contract Q75 {
    // 75. 문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
    // 예) abc,3 -> abcabcabc // ab,5 -> ababababab
    function repeatString(string memory _str, uint256 _n) public pure returns (string memory) {
        string memory result = "";
        for(uint i = 0; i < _n; i++) {
            result = string(abi.encodePacked(result, _str));
        }
        return result;
    }
}

contract Q76 {
    // 76. 숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. (패키지없이)
    function numberToString(uint256 _number) public pure returns (string memory) {
        if (_number == 0) return "0";
        
        uint256 temp = _number;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        while (_number != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(_number % 10)));
            _number /= 10;
        }
        
        return string(buffer);
    }
}

contract Q77 {
    // 77. 위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
    // 힌트 : import "@openzeppelin/contracts/utils/Strings.sol";
    import "@openzeppelin/contracts/utils/Strings.sol";
    using Strings for uint256;

    function numberToString(uint256 _number) public pure returns (string memory) {
        return _number.toString();
    }
}

contract Q78 {
    // 78. 숫자만 들어갈 수 있는 array를 선언하세요. array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
    // 예) [1,2,6,9,11,19] -> true (19는 10~25 사이) // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
    uint[] public numbers;

    function checkRange() public view returns (bool) {
        for(uint i = 0; i < numbers.length; i++) {
            if(numbers[i] >= 10 && numbers[i] <= 25) {
                return true;
            }
        }
        return false;
    }

    function addNumber(uint _number) public {
        numbers.push(_number);
    }
}

contract Q79A {
    function findMax(uint256 a, uint256 b, uint256 c) public pure returns (uint256) {
        if(a >= b && a >= c) return a;
        if(b >= a && b >= c) return b;
        return c;
    }
}

contract Q79B {
    // 79. 3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요. Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요. 학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요. 구현할 때는 Contract A를 import 하여 구현하세요.
    Q79A public calculator;
    
    struct Student {
        string name;
        uint256 number;
        uint256 score;
    }

    Student[] public students;

    constructor(address _calculator) {
        calculator = Q79A(_calculator);
    }

    function addStudent(string memory _name, uint256 _number, uint256 _score) public {
        students.push(Student(_name, _number, _score));
    }

    function getHighestScoreStudent() public view returns (Student memory) {
        require(students.length >= 3, "Need at least 3 students");
        uint256 maxScore = calculator.findMax(students[0].score, students[1].score, students[2].score);
        
        for(uint i = 0; i < students.length; i++) {
            if(students[i].score == maxScore) {
                return students[i];
            }
        }
        revert("No student found");
    }
}

contract Q80 {
    // 80. 지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 가장 먼저 들어온 것이 가장 마지막에 나갑니다. 이런 것들을FILO(First In Last Out)이라고도 합니다. 가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다. push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
    uint256[] public queue;
    uint256 public front = 0;

    function push(uint256 _value) public {
        queue.push(_value);
    }

    function pop() public returns (uint256) {
        require(front < queue.length, "Queue is empty");
        uint256 value = queue[front];
        front++;
        return value;
    }

    function length() public view returns (uint256) {
        return queue.length - front;
    }
}