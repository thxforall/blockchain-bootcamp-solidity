// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract TEACHER {
    struct STUDENT {
        string name;
        uint256 number;
        uint256 score;
        string grade;
        string[] classes;
    }

    STUDENT[] public students;

    function calculateGrade(uint256 score)
        internal
        pure
        returns (string memory)
    {
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
        string memory grade = calculateGrade(score);
        students.push(STUDENT(name, number, score, grade, classes));
    }

    function findStudentByNumber(uint256 _number)
        public
        view
        returns (STUDENT memory)
    {
        for (uint256 i = 0; i < students.length; i++) {
            if (students[i].number == _number) {
                return students[i];
            } else {
                revert("No student with the given number");
            }
        }
    }

    function findStudentByName(string memory _name)
        public
        view
        returns (STUDENT memory)
    {
        for (uint256 i = 0; i < students.length; i++) {
            if (
                keccak256((abi.encodePacked((students[i].name)))) ==
                keccak256((abi.encodePacked((_name))))
            ) {
                return students[i];
            } else {
                revert("No student with the given name");
            }
        }
    }

    function findStudentScoerByName(string memory _name)
        public
        view
        returns (uint256)
    {
        for (uint256 i = 0; i < students.length; i++) {
            if (
                keccak256((abi.encodePacked((students[i].name)))) ==
                keccak256((abi.encodePacked((_name))))
            ) {
                return students[i].score;
            } else {
                revert("No student with the given name");
            }
        }
    }

    function getAllStudentsNumber() public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](students.length);
        for (uint256 i = 0; i < students.length; i++) {
            result[i] = students[i].number;
        }
        return result;
    }

    function getAllStudents() public view returns (STUDENT[] memory) {
        STUDENT[] memory result = new STUDENT[](students.length);
        for (uint256 i = 0; i < students.length; i++) {
            result[i] = students[i];
        }
        return result;
    }

    function getScoreAVG() public view returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < students.length; i++) {
            total += students[i].score;
        }
        return (total / students.length);
    }

    function evaluateTeacher() public view returns (bool) {
        if (getScoreAVG() >= 70) {
            return true;
        } else {
            return false;
        }
    }

    function findFStudnetsTotal() internal view returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < students.length; i++) {
            if (
                keccak256((abi.encodePacked((students[i].grade)))) ==
                keccak256((abi.encodePacked(("F"))))
            ) {
                total++;
            }
        }
        return total;
    }

    function getFStudents() public view returns (STUDENT[] memory) {
        STUDENT[] memory result = new STUDENT[](findFStudnetsTotal());
        for (uint256 i = 0; i < students.length; i++) {
            if (
                keccak256((abi.encodePacked((students[i].grade)))) ==
                keccak256((abi.encodePacked(("F"))))
            ) {
                result[i] = students[i];
            }
        }
        return result;
    }

    function sortStudentsByScore(STUDENT[] memory _students)
        internal
        pure
        returns (STUDENT[] memory)
    {
        uint256 length = _students.length;
        for (uint256 i = 0; i < length; i++) {
            for (uint256 j = i + 1; j < length; j++) {
                if (_students[i].score < _students[j].score) {
                    // Swap
                    STUDENT memory temp = _students[i];
                    _students[i] = _students[j];
                    _students[j] = temp;
                }
            }
        }
        return _students;
    }

    function getSStudents() public view returns (STUDENT[] memory) {
        uint256 topCount = students.length < 4 ? students.length : 4;

        STUDENT[] memory _students = new STUDENT[](students.length);
        for (uint256 i = 0; i < students.length; i++) {
            _students[i] = students[i];
        }
        _students = sortStudentsByScore(_students);
        STUDENT[] memory result = new STUDENT[](topCount);
        for (uint256 i = 0; i < topCount; i++) {
            result[i] = _students[i];
        }

        return result;
    }
}
