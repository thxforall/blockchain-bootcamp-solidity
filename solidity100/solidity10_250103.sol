// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Q11 {
    // 11. uint 형이 들어가는 array를 선언하고, 짝수만 들어갈 수 있게 걸러주는 함수를 구현하세요.
    uint256[] uintArray;

    modifier evenFilter(uint256 _number) {
        require((_number % 2 == 0), ("Odd numbers are not allowed"));
        _;
    }

    function evenFilterArray(uint256 _number) public evenFilter(_number) {
        uintArray.push(_number);
    }

    function getArray() public view returns (uint256[] memory) {
        return uintArray;
    }
}

contract Q12 {
    // 12. 숫자 3개를 더해주는 함수, 곱해주는 함수 그리고 순서에 따라서 a*b+c를 반환해주는 함수 3개를 각각 구현하세요.
    function addNumbers(
        uint256 _a,
        uint256 _b,
        uint256 _c
    ) public pure returns (uint256) {
        return _a + _b + _c;
    }

    function mulNumbers(
        uint256 _a,
        uint256 _b,
        uint256 _c
    ) public pure returns (uint256) {
        return _a * _b * _c;
    }

    function calNumbers(
        uint256 _a,
        uint256 _b,
        uint256 _c
    ) public pure returns (uint256) {
        return _a * _b + _c;
    }
}

contract Q13 {
    // 13. 3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.

    function filterNum(uint256 _number) public pure returns (string memory) {
        require((_number > 0), "Please input valid number");
        if (_number % 3 == 0) {
            return "A";
        } else if (_number % 3 == 1) {
            return "B";
        } else if (_number % 3 == 2) {
            return "C";
        } else {
            return "The number is not supported";
        }
    }
}

contract Q14 {
    // 14. 학번, 이름, 듣는 수험 목록을 포함한 학생 구조체를 선언하고 학생들을 관리할 수 있는 array를 구현하세요.
    // array에 학생을 넣는 함수도 구현하는데 학생들의 학번은 1번부터 순서대로 2,3,4,5 자동 순차적으로 증가하는 기능도 같이 구현하세요.
    struct STUDENT {
        uint256 number;
        string name;
        string[] classes;
    }

    STUDENT[] students;
    uint256 private index = 1;

    modifier addIndex() {
        _;
        index++;
    }

    function addStudent(string memory _name, string[] memory _classes)
        public
        addIndex
    {
        STUDENT memory _student = STUDENT(index, _name, _classes);
        students.push(_student);
    }

    function getStudnets() public view returns (STUDENT[] memory) {
        return students;
    }
}

contract Q15 {
    // 15. 배열 A를 선언하고 해당 배열에 0부터 n까지 자동으로 넣는 함수를 구현하세요.
    uint256[] A;

    function pushZeroToN(uint256 _n) public {
        for (uint256 i = 0; i <= _n; i++) {
            A.push(i);
        }
    }

    function getA() public view returns (uint256[] memory) {
        return A;
    }
}

contract Q16 {
    // 16. 숫자들만 들어갈 수 있는 array를 선언하고 해당 array에 숫자를 넣는 함수도 구현하세요.
    // 또 array안의 모든 숫자의 합을 더하는 함수를 구현하세요.

    uint256[] uintArray;

    function pushArray(uint256 _number) public {
        uintArray.push(_number);
    }

    function sumArray() public view returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < uintArray.length; i++) {
            total += uintArray[i];
        }
        return total;
    }

    function getArray() public view returns (uint256[] memory) {
        return uintArray;
    }
}

contract Q17 {
    // 17. string을 input으로 받는 함수를 구현하세요.
    // 이 함수는 true 혹은 false를 반환하는데 Bob이라는 이름이 들어왔을 때에만 true를 반환합니다.

    function stringToBytes(string memory _s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_s));
    }

    function BobIsTrue(string memory _name) public pure returns (bool) {
        return (stringToBytes(_name) == stringToBytes("Bob"));
    }
}

contract Q18 {
    // 18. 이름을 검색하면 생일이 나올 수 있는 자료구조를 구현하세요.
    // (매핑) 해당 자료구조에 정보를 넣는 함수, 정보를 볼 수 있는 함수도 구현하세요.

    mapping(string => bytes32) nameHashes;
    mapping(bytes32 => uint256) birthdays;

    function setInfo(string memory _name, uint256 _birthday) public {
        require(nameHashes[_name] == 0, "Person already exists");
        bytes32 hashedName = keccak256(abi.encodePacked(_name));
        nameHashes[_name] = hashedName;
        birthdays[hashedName] = _birthday;
    }

    function getInfo(string memory _name) public view returns (uint256) {
        bytes32 hashedName = nameHashes[_name];
        require(hashedName != 0, "Person does not exist");
        return birthdays[hashedName];
    }
}

contract Q19 {
    // 19. 숫자를 넣으면 2배를 반환해주는 함수를 구현하세요. 단 숫자는 1000이상 넘으면 함수를 실행시키지 못하게 합니다.
    function doubleNum(uint256 _number) public pure returns (uint256) {
        require(_number < 1000, "Please input under 1000");
        return _number * 2;
    }
}

contract Q20 {
    // 20. 숫자만 들어가는 배열을 선언하고 숫자를 넣는 함수를 구현하세요.
    // 15개의 숫자가 들어가면 3의 배수 위치에 있는 숫자들을 초기화 시키는(3번째, 6번째, 9번째 등등) 함수를 구현하세요.
    // (for 문 응용 → 약간 까다로움)

    uint256[] numberArray;

    function pushArray(uint256 _number) public {
        numberArray.push(_number);
        if (numberArray.length >= 15) {
            for (uint256 i = 2; i < numberArray.length; i += 3) {
                delete numberArray[i];
            }
        }
    }

    function getArray() public view returns (uint256[] memory) {
        return numberArray;
    }
}
