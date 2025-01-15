// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// 숫자를 시분초로 변환하세요.
// 예) 100 -> 1분 40초, 600 -> 10분, 1000 -> 16분 40초, 5250 -> 1시간 27분 30초

contract TimeConverter {
    function timeConvert(uint256 _n) public pure returns (string memory) {
        uint256 hour = _n / 3600;
        uint256 remainSeconds = _n % 3600;
        uint256 minute = remainSeconds / 60;
        uint256 second = remainSeconds % 60;

        string memory time = "";

        if (hour > 0) {
            time = string(
                abi.encodePacked(time, uintToString(hour), unicode"시간 ")
            );
        }
        if (minute > 0) {
            time = string(
                abi.encodePacked(time, uintToString(minute), unicode"분 ")
            );
        }
        time = string(
            abi.encodePacked(time, uintToString(second), unicode"초")
        );

        return time;
    }

    // ...
    function uintToString(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 temp = _i;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_i != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(_i % 10)));
            _i /= 10;
        }
        return string(buffer);
    }
}
