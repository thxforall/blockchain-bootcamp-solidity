// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
- 31 ~ 40 (1월 11일 23:59:59)
    1. string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
        - 답안
    2. 3의 배수만 들어갈 수 있는 array를 구현하되, 3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
        
        예) 3 → o , 9 → o , 15 → o , 30 → x
        
        - 답안
    3. 이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
        - 답안
    4. 이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
        - 답안
    5. 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
        
        예) [1,2,3,4,5,6] -> [2,4,6] // [3,5,7,9,11,13] -> [5,9,13]
        
        - 답안
    6. high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
        - 답안
    7. 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
        
        (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
        
        - 답안
    8. 상태변수 a를 "A"로 설정하여 선언하세요. 이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
        
        (힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
        
        - 답안
    9. 특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
        
        예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)
        
        - 답안
    10. 숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요. 가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
        
        예) [5,2,4,7,1] -> [1,2,4,5,7], 4 // [1,5,4,9,6,3,2,11] -> [1,2,3,4,5,6,9,11], 4,5 // [6,3,1,4,9,7,8] -> [1,3,4,6,7,8,9], 6
 */


contract Q31 {
    // 31. string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
    function checkString(string memory _str) public pure returns (bool) {
        return keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked("Alice")) || keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked("Bob"));
    }
}

contract Q32 {
    // 32. 3의 배수만 들어갈 수 있는 array를 구현하되, 3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
    uint256[] public array;

    function threeTimesArray(uint256 _n) public {
        require(_n % 3 == 0, "Please input a number that is a multiple of 3");
        require(_n % 10 != 0, "Please input a number that is not a multiple of 10");

        array.push(_n);
    }
}   

contract Q33 {
    // 33. 이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
    struct Customer {
        string name;
        uint256 number;
        address walletAddress;
        uint256 birthday;
    }

    Customer[] public customers;

    function addCustomer(string memory _name, uint256 _number, address _walletAddress, uint256 _birthday) public {
        customers.push(Customer(_name, _number, _walletAddress, _birthday));
    }

    function getCustomer(string memory _name) public view returns (Customer memory) {
        for (uint256 i = 0; i < customers.length; i++) {
            if (keccak256(abi.encodePacked(customers[i].name)) == keccak256(abi.encodePacked(_name))) {
                return customers[i];
            }
        }
    }
} 

contract Q34 {
    // 34. 이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
    struct Student {
        string name;
        uint256 number;
        uint256 score;
    }

    Student[] public students;

    function addStudent(string memory _name, uint256 _number, uint256 _score) public {
        students.push(Student(_name, _number, _score));
    }

    function getAverageScore() public view returns (uint256) {
        uint256 totalScore = 0;
        for (uint256 i = 0; i < students.length; i++) {
            totalScore += students[i].score;
        }
        return totalScore / students.length;
    }   
}


contract Q35 {
    // 35. 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
    uint256[] public array;

    function addNumber(uint256 _n) public {
        array.push(_n);
    }

    function getEvenNumbers() public view returns (uint256[] memory) {
        uint256[] memory evenNumbers = new uint256[](array.length / 2);
        for (uint256 i = 0; i < array.length; i++) {
            if (i % 2 == 0) {
                evenNumbers[i / 2] = array[i];
            }
        }
        return evenNumbers;
    }
}

contract Q36 {
    // 36. high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
    enum Status {
        High,
        Neutral,
        Low
    }

    Status public status; 

    function setStatus(uint256 _n) public {
        if (_n >= 7) {
            status = Status.High;
        } else if (_n >= 4) {
            status = Status.Neutral;
        } else {
            status = Status.Low;
        }
    }
}

contract Q37 {
    // 37. 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(address => uint256) public donations;

    function donate(uint256 _amount) public {
        donations[msg.sender] += _amount;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract Q38 {
    // 38. 상태변수 a를 "A"로 설정하여 선언하세요. 이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
    string public a;
    address public owner;

    constructor() {
        owner = msg.sender;
        a = "A";
    }
    function setB() public {
        require(msg.sender == owner, "Only the owner can set the value");
        a = "B";
    }

    function setC() public {
        require(msg.sender == owner, "Only the owner can set the value");
        a = "C";
    }
}

contract Q39 {
    // 39. 특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
    function getMultiples(uint256 _n) public pure returns (uint256, uint256, uint256, uint256) {
        uint256 count2 = _n / 2;
        uint256 count3 = _n / 3;
        uint256 count5 = _n / 5;
        uint256 count7 = _n / 7;
        return (count2, count3, count5, count7);
    }
}

contract Q40 {
    // 40. 숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요. 가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
    function sortNumbers(uint256[] memory _numbers) public pure returns (uint256[] memory) {
        uint256[] memory sortedNumbers = new uint256[](_numbers.length);
        for (uint256 i = 0; i < _numbers.length; i++) {
            sortedNumbers[i] = _numbers[i];
        }
        return sortedNumbers;
    }

    function getMiddleNumber(uint256[] memory _numbers) public pure returns (uint256) {
        uint256[] memory sortedNumbers = sortNumbers(_numbers);
        uint256 middleIndex = sortedNumbers.length / 2;
        return sortedNumbers[middleIndex];
    }
}   