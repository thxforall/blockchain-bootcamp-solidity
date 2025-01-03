// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract StudentScoreManager {
    struct Student {
        uint256 id;
        string name;
        uint256 score;
    }

    Student[] private students;

    modifier studentsExist() {
        require(students.length > 0, "No students available");
        _;
    }

    function addStudent(
        uint256 _id,
        string memory _name,
        uint256 _score
    ) public {
        students.push(Student(_id, _name, _score));
    }

    function getLowestScoreStudent()
        public
        view
        studentsExist
        returns (Student memory)
    {
        Student memory lowest = students[0];
        for (uint256 i = 1; i < students.length; i++) {
            if (students[i].score < lowest.score) {
                lowest = students[i];
            }
        }
        return lowest;
    }

    function getTotalScore() public view studentsExist returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < students.length; i++) {
            total += students[i].score;
        }
        return total;
    }

    function getAverageScore() public view studentsExist returns (uint256) {
        return getTotalScore() / students.length;
    }

    function getStudentById(uint256 _id)
        public
        view
        studentsExist
        returns (Student memory)
    {
        for (uint256 i = 0; i < students.length; i++) {
            if (students[i].id == _id) {
                return students[i];
            }
        }
        revert("Student not found");
    }

    function getAllStudents()
        public
        view
        studentsExist
        returns (Student[] memory)
    {
        return students;
    }
}
