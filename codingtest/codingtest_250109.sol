// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.
입력값을 받으면 그 입력값 안에 대문자, 소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 알려주는 함수를 구현하세요.
*/

contract PASSWORD {
    function _special(string memory _s) internal pure returns (bool) {
        // 33~47, 58~64, 91~96, 123~126
        bytes memory _bytes = bytes(_s);
        for (uint256 i = 0; i < _bytes.length; i++) {
            uint8 char = uint8(_bytes[i]);
            if (
                (char >= 33 && char <= 47) ||
                (char >= 58 && char <= 64) ||
                (char >= 91 && char <= 96) ||
                (char >= 123 && char <= 126)
            ) {
                return true;
            }
        }
        return false;
    }

    function _upperCase(string memory _s) internal pure returns (bool) {
        // 65~90
        bytes memory _bytes = bytes(_s);
        for (uint256 i = 0; i < _bytes.length; i++) {
            uint8 char = uint8(_bytes[i]);
            if (char >= 65 && char <= 90) {
                return true;
            }
        }
        return false;
    }

    function _lowerCase(string memory _s) internal pure returns (bool) {
        // 97~122
        bytes memory _bytes = bytes(_s);
        for (uint256 i = 0; i < _bytes.length; i++) {
            uint8 char = uint8(_bytes[i]);
            if (char >= 97 && char <= 122) {
                return true;
            }
        }
        return false;
    }

    function _number(string memory _s) internal pure returns (bool) {
        // 48~57
        bytes memory _bytes = bytes(_s);
        for (uint256 i = 0; i < _bytes.length; i++) {
            uint8 char = uint8(_bytes[i]);
            if (char >= 48 && char <= 57) {
                return true;
            }
        }
        return false;
    }

    function isValidPassword(string memory _password)
        public
        pure
        returns (bool)
    {
        return
            _upperCase(_password) &&
            _lowerCase(_password) &&
            _number(_password) &&
            _special(_password);
    }
}
