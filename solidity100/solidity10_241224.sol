// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Q1 {
    // 1. 더하기, 빼기, 곱하기, 나누기 그리고 제곱을 반환받는 계산기를 만드세요.
    struct Cal {
        uint256 a;
        string operation;
        uint256 b;
    }

    function calculator(Cal memory _cal) public pure returns (uint256 result) {
        if (
            keccak256((abi.encodePacked(_cal.operation))) ==
            keccak256(abi.encodePacked("+"))
        ) {
            return _cal.a + _cal.b;
        } else if (
            keccak256((abi.encodePacked(_cal.operation))) ==
            keccak256(abi.encodePacked("-"))
        ) {
            require(_cal.a >= _cal.b, "Can not substract under zero");
            return _cal.a - _cal.b;
        } else if (
            (keccak256((abi.encodePacked(_cal.operation))) ==
                keccak256(abi.encodePacked("*")))
        ) {
            return _cal.a * _cal.b;
        } else if (
            (keccak256((abi.encodePacked(_cal.operation))) ==
                keccak256(abi.encodePacked("/")))
        ) {
            require(_cal.b != 0, "Can not divide by zero");
            return _cal.a / _cal.b;
        } else if (
            (keccak256((abi.encodePacked(_cal.operation))) ==
                keccak256(abi.encodePacked("^")))
        ) {
            return _cal.a**_cal.b;
        } else {
            revert("Please input valid operation ex) '+','-' ... ");
        }
    }
}

contract Q2 {
    // 2. 2개의 Input값을 가지고 1개의 output값을 가지는 4개의 함수를 만드시오. 각각의 함수는 더하기, 빼기, 곱하기, 나누기(몫)를 실행합니다.
    function add(uint256 _a, uint256 _b) public pure returns (uint256) {
        return (_a + _b);
    }

    function sub(uint256 _a, uint256 _b) public pure returns (uint256) {
        require(_a >= _b, "Can not substract under zero");
        return _a - _b;
    }

    function mul(uint256 _a, uint256 _b) public pure returns (uint256) {
        return (_a * _b);
    }

    function div(uint256 _a, uint256 _b) public pure returns (uint256) {
        require(_b != 0, "Can not divide by zero");
        return (_a / _b);
    }
}

contract Q3 {
    // 3. 1개의 Input값을 가지고 1개의 output값을 가지는 2개의 함수를 만드시오. 각각의 함수는 제곱, 세제곱을 반환합니다.
    function multiSquaire(uint256 _n) public pure returns (uint256 result) {
        return _n**2;
    }

    function multiCube(uint256 _n) public pure returns (uint256 result) {
        return _n**3;
    }
}

contract Q4 {
    // 4. 이름(string), 번호(uint), 듣는 수업 목록(string[])을 담은 student라는 구조체를 만들고 그 구조체들을 관리할 수 있는 array, students를 선언하세요.
    struct Student {
        string name;
        uint256 number;
        string[] classes;
    }

    Student[] public students;
}

contract Q5 {
    // 5. 아래의 함수를 만드세요 1~3을 입력하면 입력한 수의 제곱을 반환받습니다
    // 4~6을 입력하면 입력한 수의 2배를 반환받습니다. 7~9를 입력하면 입력한 수를 3으로 나눈 나머지를 반환받습니다.
    function q5(uint256 _n) public pure returns (uint256 result) {
        if (_n >= 1 && _n <= 3) {
            return _n**2;
        } else if (_n >= 4 && _n <= 6) {
            return _n * 2;
        } else if (_n >= 7 && _n <= 9) {
            return _n % 3;
        } else {
            revert("Invalid input: Number not supported");
        }
    }
}

contract Q6 {
    // 6. 숫자만 들어갈 수 있는 array numbers를 만들고 그 array안에 0부터 9까지 자동으로 채우는 함수를 구현하세요.(for 문)
    uint256[] numbers;

    function arrayFillToNine() public {
        for (uint256 i = 0; i <= 9; i++) {
            numbers.push(i);
        }
    }

    function getNumbers() public view returns (uint256[] memory) {
        return numbers;
    }
}

contract Q7 {
    // 숫자만 들어갈 수 있는 array numbers를 만들고 그 array안에 0부터 5까지 자동으로 채우는 함수와
    //  array안의 모든 숫자를 더한 값을 반환하는 함수를 각각 구현하세요.(for 문)
    uint256[] numbers;

    function arrayFillToFive() public {
        for (uint256 i = 0; i <= 5; i++) {
            numbers.push(i);
        }
    }

    function getNumbers() public view returns (uint256 result) {
        for (uint256 i = 0; i < numbers.length; i++) {
            result += numbers[i];
        }
        return result;
    }
}

contract Q8 {
    // 8. 1~10을 입력하면 “A” 반환받습니다.
    // 11~20을 입력하면 “B” 반환받습니다.
    // 21~30을 입력하면 “C” 반환받습니다.

    function returnABC(uint256 _n) public pure returns (string memory result) {
        if (_n >= 1 && _n <= 10) {
            return "A";
        } else if (_n >= 11 && _n <= 20) {
            return "B";
        } else if (_n >= 21 && _n <= 30) {
            return "C";
        } else {
            revert("Invalid input: Number not supported");
        }
    }
}

contract Q9 {
    // 9. 문자형을 입력하면 bytes 형으로 변환하여 반환하는 함수를 구현하세요.
    function stringToBytes(string memory _s)
        public
        pure
        returns (bytes memory result)
    {
        return abi.encodePacked(_s);
    }
}

contract Q10 {
    // 10. 숫자만 들어가는 array numbers를 선언하고 숫자를 넣고(push), 빼고(pop), 특정 n번째 요소의 값을 볼 수 있는(get)함수를 구현하세요.
    uint256[] numbers;

    function pushArray(uint256 _n) public {
        numbers.push(_n);
    }

    function popArray() public {
        numbers.pop();
    }

    function getArrayByIndex(uint256 _n) public view returns (uint256 result) {
        return numbers[_n - 1];
    }
}
