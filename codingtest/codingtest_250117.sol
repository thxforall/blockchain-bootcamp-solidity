// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
    숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요. (숫자는 작은수에서 큰수로)
    예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   3,5,9 // 28712 -> 5,   1,2,2,7,8
    --------------------------------------------------------------------------------------------
    문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요. (알파벳은 순서대로)
    예) abde -> 4,   a,b,d,e // fkeadf -> 6,   a,d,e,f,f,k
*/

contract FILTER {
    function countDigits(uint256 _n) internal pure returns (uint256 count) {
        do {
            count++;
            _n /= 10;
        } while (_n > 0);
        return count;
    }

    function uintToArray(uint256 _n) internal pure returns (uint256[] memory) {
        uint256 _length = countDigits(_n);
        uint256[] memory uintArray = new uint256[](_length);

        for (uint256 i = _length; i > 0; i--) {
            uintArray[i - 1] = _n % 10;
            _n /= 10;
        }
        return uintArray;
    }

    function sortUintArray(uint256[] memory _arr)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256 length = _arr.length;

        for (uint256 i = 0; i < length; i++) {
            for (uint256 j = 0; j < length - 1 - i; j++) {
                if (_arr[j] > _arr[j + 1]) {
                    uint256 temp = _arr[j];
                    _arr[j] = _arr[j + 1];
                    _arr[j + 1] = temp;
                }
            }
        }
        return _arr;
    }

    function stringToCharArray(string memory _str)
        internal
        pure
        returns (bytes memory)
    {
        return bytes(_str);
    }

    function sortCharArray(bytes memory _arr)
        internal
        pure
        returns (bytes memory)
    {
        uint256 length = _arr.length;

        for (uint256 i = 0; i < length; i++) {
            for (uint256 j = 0; j < length - 1 - i; j++) {
                if (_arr[j] > _arr[j + 1]) {
                    bytes1 temp = _arr[j];
                    _arr[j] = _arr[j + 1];
                    _arr[j + 1] = temp;
                }
            }
        }
        return _arr;
    }

    function processNumber(uint256 _n)
        public
        pure
        returns (uint256, uint256[] memory)
    {
        uint256[] memory digits = uintToArray(_n);
        sortUintArray(digits);
        return (digits.length, digits);
    }

    function processString(string memory _str)
        public
        pure
        returns (uint256, bytes memory)
    {
        bytes memory chars = bytes(_str);
        sortCharArray(chars);
        return (chars.length, chars);
    }
}
