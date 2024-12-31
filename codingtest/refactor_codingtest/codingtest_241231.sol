// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*  
    <Code Reiview with GPT>

    1. 코드 가독성과 유지보수성
    findStudentByNumber, findStudentByName, findStudentScoerByName 함수에서 
    revert를 사용하는 대신, 루프가 끝난 후 revert를 호출하는 방식으로 수정하세요. 
    현재 구조에서는 루프 중에 조건이 충족되지 않아도 계속 revert가 호출될 수 있습니다.

    2. abi.encodePacked 사용
    abi.encodePacked는 문자열 비교에서 사용되었는데, 이는 가스 소비가 크고, 단순 비교에서는 효율적이지 않습니다. 
    대신 bytes로 변환한 후 비교하거나, mapping을 활용해 효율성을 높일 수 있습니다.

    3. F 학생 조회 기능(getFStudents)
    findFStudnetsTotal 함수와 getFStudents 함수가 중복적으로 배열을 순회하고 있습니다.
    배열 크기를 먼저 구하고 다시 순회하는 것은 비효율적입니다.

    4. S반 학생 조회(getSStudents)
    점수 정렬 로직이 삽입 정렬(O(n^2))을 사용하고 있어 큰 배열에서는 비효율적입니다.
    정렬이 필요한 경우, Solidity의 sorting libraries를 사용하거나 별도의 점수 저장 방식을 고려하세요.

    5. 가스 최적화
    getAllStudents, getAllStudentsNumber 함수는 배열 크기가 커지면 비효율적입니다.
    STUDENT[] 전체를 반환하면 데이터 양이 많아 가스 비용이 크게 증가합니다.
    학생 데이터를 조회할 때, 필요한 필드만 반환하도록 설계하거나 paging을 구현하세요.
    
    6. 추가적인 개선 사항
    변수 명명: findFStudnetsTotal 오타 수정 (findFStudentsTotal).
    공통 로직 추출: 학생 검색, 정렬 등의 반복되는 로직은 별도의 내부 함수로 추출하여 재사용성을 높일 수 있습니다.

*/

contract TEACHER {
    struct STUDENT {
        string name;
        uint256 number;
        uint256 score;
        string grade;
        string[] classes;
    }

    STUDENT[] public students;
    mapping(string => uint256) private studentNameIndex;

    function calculateGrade(uint256 score) internal pure returns (string memory) {
        if (score >= 90) {
            return "A";
        } else if (score >= 80) {
            return "B";
        } else if (score >= 70) {
            return "C";
        } else if (score >= 60) {
            return "D";
        } else {
            return "F";
        }
    }

    function addStudent(
        string memory name,
        uint256 number,
        uint256 score,
        string[] memory classes
    ) public {
        require(studentNameIndex[name] == 0, "Student already exists");
        string memory grade = calculateGrade(score);
        students.push(STUDENT(name, number, score, grade, classes));
        studentNameIndex[name] = students.length;
    }

    function findStudentByNumber(uint256 _number) public view returns (STUDENT memory) {
        for (uint256 i = 0; i < students.length; i++) {
            if (students[i].number == _number) {
                return students[i];
            }
        }
        revert("No student with the given number");
    }

    function findStudentByName(string memory _name) public view returns (STUDENT memory) {
        uint256 index = studentNameIndex[_name];
        require(index > 0, "No student with the given name");
        return students[index - 1];
    }

    function findStudentScoreByName(string memory _name) public view returns (uint256) {
        uint256 index = studentNameIndex[_name];
        require(index > 0, "No student with the given name");
        return students[index - 1].score;
    }

    function getAllStudentsNumber() public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](students.length);
        for (uint256 i = 0; i < students.length; i++) {
            result[i] = students[i].number;
        }
        return result;
    }

    function getAllStudents() public view returns (STUDENT[] memory) {
        return students;
    }

    function getScoreAVG() public view returns (uint256) {
        require(students.length > 0, "No students available");
        uint256 total;
        for (uint256 i = 0; i < students.length; i++) {
            total += students[i].score;
        }
        return total / students.length;
    }

    function evaluateTeacher() public view returns (bool) {
        return getScoreAVG() >= 70;
    }

    function getFStudents() public view returns (STUDENT[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < students.length; i++) {
            if (keccak256(bytes(students[i].grade)) == keccak256(bytes("F"))) {
                count++;
            }
        }
        STUDENT[] memory result = new STUDENT[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < students.length; i++) {
            if (keccak256(bytes(students[i].grade)) == keccak256(bytes("F"))) {
                result[index] = students[i];
                index++;
            }
        }
        return result;
    }

    function getSStudents() public view returns (STUDENT[] memory) {
        uint256 topCount = students.length < 4 ? students.length : 4;

        STUDENT[] memory sortedStudents = students;
        for (uint256 i = 0; i < sortedStudents.length; i++) {
            for (uint256 j = i + 1; j < sortedStudents.length; j++) {
                if (sortedStudents[i].score < sortedStudents[j].score) {
                    STUDENT memory temp = sortedStudents[i];
                    sortedStudents[i] = sortedStudents[j];
                    sortedStudents[j] = temp;
                }
            }
        }

        STUDENT[] memory result = new STUDENT[](topCount);
        for (uint256 i = 0; i < topCount; i++) {
            result[i] = sortedStudents[i];
        }

        return result;
    }
}
