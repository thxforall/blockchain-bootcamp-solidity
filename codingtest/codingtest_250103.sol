// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract AUTH {
    mapping(string => bytes32) private user;
    mapping(string => uint256) private loginAttempts;

    function hashingUser(string memory _id, string memory _pw)
        private
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_id, _pw));
    }

    function incrementLoginAttempts(string memory _id) private {
        loginAttempts[_id]++;
    }

    function resetUser(string memory _id) private {
        delete user[_id];
        delete loginAttempts[_id];
    }

    modifier validateInput(string memory _id, string memory _pw) {
        require(bytes(_id).length > 0, "ID cannot be empty");
        require(bytes(_pw).length > 0, "Password cannot be empty");
        _;
    }

    modifier checkId(string memory _id) {
        require(user[_id] == 0, "ID already exists");
        _;
    }

    function register(string memory _id, string memory _pw)
        public
        validateInput(_id, _pw)
        checkId(_id)
    {
        user[_id] = hashingUser(_id, _pw);
    }

    function login(string memory _id, string memory _pw)
        public
        validateInput(_id, _pw)
        returns (bool)
    {
        require(
            loginAttempts[_id] < 5,
            "Too many failed attempts. Account locked."
        );

        if (user[_id] == hashingUser(_id, _pw)) {
            loginAttempts[_id] = 0;
            return true;
        } else {
            incrementLoginAttempts(_id);
            return false;
        }
    }

    function deleteUser(string memory _id, string memory _pw)
        public
        validateInput(_id, _pw)
    {
        require(user[_id] != 0, "User does not exist");

        if (user[_id] == hashingUser(_id, _pw)) {
            resetUser(_id);
        } else {
            revert("Incorrect password");
        }
    }
}
