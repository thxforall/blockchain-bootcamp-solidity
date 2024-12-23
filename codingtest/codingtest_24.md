```
// SPDX-License-Identifier: GPL-3.o

pragma solidity >=0.8.2 <0.9.0;

contract TEACHER {
    struct student {
        string name;
        uint number;
        uint score;
        string grade;
    }

    // number는 array에 추가될때마다 1부터 1씩 증가
    // array index는 상태변수로 저장해야하는 가
    // grade는 점수대를 나누어 A,B,C,D로 저장
    // grade를 mapping 할 수 있을까

    student[] class;

    // 학생 추가기능
    function addStudent(student memory _s) public {
        class.push(_s);
    }
    // 학생 조회 기능 by 번호
    function getStudentByNumber(uint _number) public view returns(student memory) {
        student memory result;
        for(uint i = 0; i < class.length - 1; i++) {
            if(class[i].number == _number) {
                result = class[i];
            }
        }
        return result;
    }
    // 학생 조회 기능 by 이름
    function getStudentByName(string memory _name) public view returns(student memory) {
        student memory result;
        for(uint i = 0; i < class.length - 1; i++) {
            if(class[i].name === _name) {
                result = class[i];
            }
        }
        return result;
    }
    // 학생 전체 숫자 조회
    function getAllStudentNumber() public view returns(uint) {
        return class.length - 1;
    }
}
```
