// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Constants/Errors.const.sol";

contract UserContract {
    
    enum Gender { Male, Female, Other }

    struct User {
        string fullName;
        uint256 dateOfBirth;
        Gender gender;
    }

    mapping(address => User) private users;

    function createUserData(string memory _fullName, uint256 _dateOfBirth, Gender _gender) public {
        require(users[msg.sender].dateOfBirth == 0, ErrorCodes.ERROR_USER_IS_NOT_FOUND);
        users[msg.sender] = User(_fullName, _dateOfBirth, _gender);
    }                                                                                                                                                                                                                                                                           

    function getMyUserData() public view returns (User memory) {
        require(users[msg.sender].dateOfBirth > 0, ErrorCodes.ERROR_USER_IS_NOT_FOUND);

        User memory user = users[msg.sender];
        return user;
    }

    function getOtherUserData(address userAddr) public view returns (User memory) {
        require(users[msg.sender].dateOfBirth > 0, ErrorCodes.ERROR_USER_IS_CREATED);

        User memory user = users[userAddr];
        return user;
    }
}
