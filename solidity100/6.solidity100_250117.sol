// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Q51 {
    // 51. 숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
    uint256[] public uintArray;

    function addNumber(uint256 _num) public {
        uintArray.push(_num);
    }

    function getThirdLargest() public view returns (uint256) {
        require(uintArray.length >= 3, "Not enough array");

        uint256[] memory sortArray = uintArray;

        for (uint256 i = 0; i < sortArray.length; i++) {
            for (uint256 j = i + 1; j < sortArray.length; j++) {
                if (sortArray[i] < sortArray[j]) {
                    // Swap
                    uint256 temp = sortArray[i];
                    sortArray[i] = sortArray[j];
                    sortArray[j] = temp;
                }
            }
        }
        return sortArray[2];
    }
}

contract Q52 {
    // 52. 자동으로 아이디를 만들어주는 함수를 구현하세요. 이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.

    function makeId(
        string memory _name,
        uint256 _birth,
        address _addr
    ) public pure returns (bytes10) {
        bytes32 hash = keccak256(abi.encodePacked(_name, _birth, _addr));
        return bytes10(hash);
    }
}

contract Q53 {
    // 53.시중에는 A,B,C,D,E 5개의 은행이 있습니다. 각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
    enum Bank {
        A,
        B,
        C,
        D,
        E
    }
    mapping(Bank => mapping(address => uint256)) private bankBalances;

    function deposit(Bank bank) public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        bankBalances[bank][msg.sender] += msg.value;
    }

    function withdraw(Bank bank, uint256 amount) public {
        require(
            bankBalances[bank][msg.sender] >= amount,
            "Insufficient balance"
        );
        bankBalances[bank][msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getBalance(Bank bank) public view returns (uint256) {
        return bankBalances[bank][msg.sender];
    }
}

contract Q54 {
    // 54. 기부받는 플랫폼을 만드세요. 가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.

    mapping(address => uint256) public donations;
    address public highestDonator;
    uint256 public highestDonation;

    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than zero");
        donations[msg.sender] += msg.value;

        if (donations[msg.sender] > highestDonation) {
            highestDonation = donations[msg.sender];
            highestDonator = msg.sender;
        }
    }

    // 특정 기부자의 총 기부 금액 확인
    function getDonation(address donor) public view returns (uint256) {
        return donations[donor];
    }

    // 현재 가장 높은 기부자와 기부 금액 반환
    function getFirstDonator() public view returns (address, uint256) {
        return (highestDonator, highestDonation);
    }
}

contract Q55 {
    // 55. 배포와 함께 owner를 설정하고 owner를 다른 주소로 바꾸는 것은 오직 owner 스스로만 할 수 있게 하십시오.
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier checkAuth() {
        require(owner == msg.sender, "Can't access");
        _;
    }

    function changeAuth() public checkAuth {
        owner = msg.sender;
    }
}

contract Q56 {
    // 56. 위 문제의 확장버전입니다. owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요.
    address private owner;
    address private sub_owner;
    mapping(address => bool) private approvals;

    constructor(address _subOwner) {
        require(_subOwner != address(0), "Can't Zero");
        owner = msg.sender;
        sub_owner = _subOwner;
    }

    modifier checkAuth() {
        require(msg.sender == owner || msg.sender == sub_owner, "Can't access");
        _;
    }

    function approval() public checkAuth {
        approvals[msg.sender] = true;
    }

    function changeAuth(address _newOwner) public checkAuth {
        require(_newOwner != address(0), "Can't Zero");
        require(approvals[msg.sender] && approvals[sub_owner], "Can't Change");

        owner = _newOwner;
        approvals[owner] = false;
        approvals[sub_owner] = false;
    }
}

contract Q57 {
    // 57. 위 문제의 또다른 버전입니다. owner가 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 한다면 owner의 동의가 필요하게 구현하세요.

    address private owner;
    address private sub_owner;
    mapping(address => bool) private approvals;

    constructor(address _subOwner) {
        require(_subOwner != address(0), "Can't Zero");
        owner = msg.sender;
        sub_owner = _subOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Can't access");
        _;
    }

    modifier onlySubOwner() {
        require(msg.sender == sub_owner, "Can't access");
        _;
    }

    modifier nonZeroAddress(address _addr) {
        require(_addr != address(0), "Can't Zero");
        _;
    }

    function changeOwner(address _newOwner)
        public
        onlyOwner
        nonZeroAddress(_newOwner)
    {
        owner = _newOwner;
    }

    function requestSubOwnerChange(address _newSubOwner)
        public
        onlySubOwner
        nonZeroAddress(_newSubOwner)
    {
        approvals[_newSubOwner] = true;
    }

    function approveSubOwnerChange(address _newSubOwner) public onlyOwner {
        require(approvals[_newSubOwner], "Can't access");
        sub_owner = _newSubOwner;
        approvals[_newSubOwner] = false;
    }
}

contract Q58 {
    // 58. A contract에 a,b,c라는 상태변수가 있습니다.
    // a는 A 외부에서는 변화할 수 없게 하고 싶습니다.
    // b는 상속받은 contract들만 변경시킬 수 있습니다.
    // c는 제한이 없습니다. 각 변수들의 visibility를 설정하세요.

    uint256 private a;
    uint256 internal b;
    uint256 public c;
}

contract Q59 {
    // 59. 현재시간을 받고 2일 후의 시간을 설정하는 함수를 같이 구현하세요.

    uint256 public twoDaysTime;

    function setTwoDaysTime() public {
        uint256 currentTime = block.timestamp;
        twoDaysTime = currentTime + 2 days;
    }
}

contract Q60 {
    // 1. 방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다.
    // 특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.
    // 예약시스템은 운영하지 않아도 됩니다. 과거의 일만 기록한다고 생각하세요.
    // 힌트 : 날짜는 그냥 숫자로 기입하세요. 예) 2023년 5월 27일 → 230527

    mapping(uint256 => mapping(uint256 => string[3])) private roomBookings;

    function addGuests(
        uint256 date,
        uint256 room,
        string[3] memory guests
    ) public {
        require(room == 1 || room == 2, "Invalid room");
        roomBookings[date][room] = guests;
    }

    function getGuests(uint256 date, uint256 room)
        public
        view
        returns (string[3] memory)
    {
        require(room == 1 || room == 2, "Invalid room");
        return roomBookings[date][room];
    }
}
