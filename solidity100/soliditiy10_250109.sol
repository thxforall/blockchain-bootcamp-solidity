// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Q21 {
    // 21. 3의 배수만 들어갈 수 있는 array를 구현하세요.
    uint256[] public array;

    function threeTimesArray(uint256 _n) public {
        require(_n % 3 == 0, "Please input a number that is a multiple of 3");
        array.push(_n);
    }

    function getArray() public view returns (uint256[] memory) {
        return array;
    }
}

contract Q22 {
    // 22. 뺄셈 함수를 구현하세요. 임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.
    function subNum(uint256 _a, uint256 _b) public pure returns (uint256) {
        if (_a >= _b) {
            return _a - _b;
        } else {
            return _b - _a;
        }
    }
}

contract Q23 {
    // 23. 5의 배수라면 “A”를, 나머지가 1이면 “B”를, 나머지가 2면 “C”를, 나머지가 3이면 “D”, 나미저가 4면 “E”를 반환하는 함수를 구현하세요.
    function filterNum(uint256 _number) public pure returns (string memory) {
        require((_number > 0), "Please input valid number");
        if (_number % 5 == 0) {
            return "A";
        } else if (_number % 5 == 1) {
            return "B";
        } else if (_number % 5 == 2) {
            return "C";
        } else if (_number % 5 == 3) {
            return "D";
        } else if (_number % 5 == 4) {
            return "E";
        } else {
            return "The number is not supported";
        }
    }
}

contract Q24 {
    // 24. string을 input으로 받는 함수를 구현하세요. “Alice”가 들어왔을 때에만 true를 반환하세요.
    function findAlice(string memory _s) public returns (bool) {
        if (
            keccak256(abi.encodePacked("Alice")) ==
            keccak256(abi.encodePacked(_s))
        ) {
            return true;
        }
        return false;
    }
}

contract Q25 {
    // 25. 배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요.
    uint256[] public A;

    function pushToN(uint256 _n) public {
        for (uint256 i = _n; i > 0; i--) {
            A.push(i);
        }
        A.push(0);
    }

    function getA() public view returns (uint256[] memory) {
        return A;
    }
}

contract Q26 {
    // 26. 홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 숫자를 넣었을 때 자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
    uint256[] public oddArray;
    uint256[] public evenArray;

    function pushArrayFilter(uint256 _n) public {
        if (_n == 0) {
            revert("Please Input Over Zero");
        }

        if (_n % 2 == 0) {
            evenArray.push(_n);
        } else {
            oddArray.push(_n);
        }
    }

    function getArrays()
        public
        view
        returns (uint256[] memory, uint256[] memory)
    {
        return (oddArray, evenArray);
    }
}

contract Q27 {
    // 27. string 과 bytes32를 _s-value 쌍으로 묶어주는 mapping을 구현하세요.
    // 해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.

    mapping(string => bytes32) public id;

    function setId(string memory _s) public {
        require(id[_s] == bytes32(0), "Already exists");
        id[_s] = keccak256(abi.encodePacked(_s));
    }

    modifier hasId(string memory _s) {
        require(id[_s] != bytes32(0), "Id does not exist");
        _;
    }

    function getValue(string memory _s)
        public
        view
        hasId(_s)
        returns (bytes32)
    {
        return id[_s];
    }

    function delete_s(string memory _s) public hasId(_s) {
        delete id[_s];
    }
}

contract Q28 {
    // 28. ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
    function userHash(string memory _id, string memory _pw)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_id, _pw));
    }
}

contract Q29 {
    // 29. 숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
    uint256 public a;
    string b;

    constructor() {
        a = 10;
        b = "A";
    }
}

contract Q30 {
    // 30.임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요 (sorting 코드 응용 → 약간 까다로움)
    uint256[] public array;

    function sortingArray(uint256[] memory _array)
        public
        pure
        returns (uint256[] memory)
    {
        if (_array.length > 1) {
            for (uint256 i = 0; i < _array.length - 1; i++) {
                for (uint256 j = i + 1; j < _array.length; j++) {
                    if (_array[i] < _array[j]) {
                        // Swap elements
                        uint256 temp = _array[i];
                        _array[i] = _array[j];
                        _array[j] = temp;
                    }
                }
            }
        }
        return _array;
    }

    function pushArray(uint256 _n) public {
        array.push(_n);
        sortingArray(array);
    }

    function getArray() public view returns (uint256[] memory) {
        return array;
    }
}
