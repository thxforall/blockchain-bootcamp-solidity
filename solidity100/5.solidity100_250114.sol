// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// import "@openzeppelin/contracts/utils/Strings.sol";

contract Q41 {
    // 41. 숫자만 들어갈 수 있으며 길이가 4인 배열을 (상태변수로)선언하고 그 배열에 숫자를 넣는 함수를 구현하세요.
    // 배열을 초기화하는 함수도 구현하세요. (길이가 4가 되면 자동으로 초기화하는 기능은 굳이 구현하지 않아도 됩니다.)
    uint256[4] public array;
    uint8 public arrayIndex = 0;

    function arrayPush(uint256 _n) public {
        if (arrayIndex > 3) {
            for (uint256 i = 0; i < 4; i++) {
                delete array[i];
            }
        } else {
            array[arrayIndex] = _n;
            arrayIndex++;
        }
    }
}

contract Q42 {
    // 42. 이름과 번호 그리고 지갑주소를 가진 '고객'이라는 구조체를 선언하세요.
    // 새로운 고객 정보를 만들 수 있는 함수도 구현하되 이름의 글자가 최소 5글자가 되게 설정하세요.
    struct Customer {
        string name;
        uint256 number;
        address personalAddress;
    }

    function newCustomer(string memory _name)
        public
        view
        returns (Customer memory)
    {   
        require(bytes(_name).length >= 5, "Name must be at least 5 characters");
        return Customer({
            name: _name,
            number: uint256(keccak256(abi.encodePacked(msg.sender))),
            personalAddress: msg.sender
        });
    }
}

contract Q43 {
    // 43. 은행의 역할을 하는 contract를 만드려고 합니다. 별도의 고객 등록 과정은 없습니다.
    // 해당 contract에 ether를 예치할 수 있는 기능을 만드세요.
    // 또한, 자신이 현재 얼마를 예치했는지도 볼 수 있는 함수 그리고 자신이 예치한만큼의 ether를 인출할 수 있는 기능을 구현하세요. (mapping)
    mapping(address => uint256) private deposits;

    function deposit() public payable {
        require(msg.value>0, "More than 0");
        deposits[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint256 myBalance) {
        myBalance = address(this).balance;
    }

    function withdraw(uint256 _amount) public {
        require(deposits[msg.sender] >= _amount, "Insufficient balance");
        deposits[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}

contract Q44 {
    // 44. string만 들어가는 array를 만들되, 4글자 이상인 문자열만 들어갈 수 있게 구현하세요.
    string[] public strings;

    modifier checkStringLength(string memory _s) {
        require(bytes(_s).length > 3, "Can't push under 4 length string");
        _;
    }

    function stringsPush(string memory _s) public checkStringLength(_s) {
        strings.push(_s);
    }
}

contract Q45 {
    // 45. 숫자만 들어가는 array를 만들되, 100이하의 숫자만 들어갈 수 있게 구현하세요.
    uint[] public uints;

    modifier checkUint(uint _n) {
        require(_n < 101, "Can't push over 100");
        _;
    }

    function uintsPush(uint _n) public checkUint(_n) {
        uints.push(_n);
    }
}

contract Q46 {
    // 46. 3의 배수이거나 10의 배수이면서 50보다 작은 수만 들어갈 수 있는 array를 구현하세요.
    // (예 : 15 -> 가능, 3의 배수 // 40 -> 가능, 10의 배수이면서 50보다 작음 // 66 -> 가능, 3의 배수 // 70 -> 불가능 10의 배수이지만 50보다 큼)
    uint[] public filterArr;

    modifier filter(uint _n) {
        require(((_n % 3 == 0 || _n % 10 ==0) && _n < 50), "Filtering Number!");
        _;
    }

    function arrPush(uint _n) public filter(_n) {
        filterArr.push(_n);
    }
}

contract Q47 {
    // 47. 배포와 함께 배포자가 owner로 설정되게 하세요. owner를 바꿀 수 있는 함수도 구현하되 그 함수는 owner만 실행할 수 있게 해주세요.
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier checkAuth(address _addr) {
        require(owner == msg.sender, "Can't access");
        _;
    }

    function changeAuth() public checkAuth(msg.sender) {
        owner = msg.sender;
    }
}

contract Q481 {
    // 48. A라는 contract에는 2개의 숫자를 더해주는 함수를 구현하세요. B라고 하는 contract를 따로 만든 후에 A의 더하기 함수를 사용하는 코드를 구현하세요.
    function add(uint _a, uint _b) public pure returns(uint result) {
        result = _a + _b;
    }
}

contract Q482 {
    // 48. A라는 contract에는 2개의 숫자를 더해주는 함수를 구현하세요. B라고 하는 contract를 따로 만든 후에 A의 더하기 함수를 사용하는 코드를 구현하세요.   
    Q481 public q84Fn;

    constructor(address _ca) {
        q84Fn = Q481(_ca);
    }

    function add(uint _a, uint _b) public view returns(uint result) {
        result = q84Fn.add(_a,_b);
    }
}

contract Q49 {
    // 49. 긴 숫자를 넣었을 때, 마지막 3개의 숫자만 반환하는 함수를 구현하세요.
    // 예) 459273 → 273 // 492871 → 871 // 92218 → 218

    function sliceNum(uint _n) public pure returns (uint result) {
        result = _n % 1000;
    }
}

contract Q50 {
    // 숫자 3개가 부여되면 그 3개의 숫자를 이어붙여서 반환하는 함수를 구현하세요.
    // 예) 3,1,6 → 316 // 1,9,3 → 193 // 0,1,5 → 15
    // 응용 문제 : 3개 아닌 n개의 숫자 이어붙이기

    function digitsCount(uint _n) internal pure returns (uint) {
        uint digits = 0;
        while (_n != 0) {
            digits++;
            _n /= 10;
        }
        return digits > 0 ? digits : 1;
    }

    function concatUint(uint _n1, uint _n2, uint _n3) public pure returns (uint) {
        uint digits2 = digitsCount(_n2); 
        uint digits3 = digitsCount(_n3);

        return _n1 * 10**(digits2 + digits3) + _n2 * 10**digits3 + _n3;
    }
}
