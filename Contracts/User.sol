// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Constants/Errors.const.sol";
import "Contracts/RoleManager.sol";

contract UserContract {
    RoleManager roleManager;
    enum Gender { Male, Female, Other }

    struct User {
        string fullName;
        uint256 dateOfBirth;
        Gender gender;
    }

    mapping(address => User) private users;

    constructor(address _roleManagerAddress) {
        roleManager = RoleManager(_roleManagerAddress);
        
        users[msg.sender] = User("Admin", 10000000, Gender.Other);
    }

    modifier userIsNotCreated(address userAddr) {
        require(users[userAddr].dateOfBirth == 0, ErrorCodes.ERROR_USER_IS_CREATED);
        _;
    }

    modifier userIsFound(address userAddr) {
        require(users[userAddr].dateOfBirth > 0, ErrorCodes.ERROR_USER_IS_NOT_FOUND);
        _;
    }

    function createUser(string memory _fullName, uint256 _dateOfBirth, Gender _gender) 
    public userIsNotCreated(msg.sender) {
        users[msg.sender] = User(_fullName, _dateOfBirth, _gender);
        roleManager.setStudentRole(msg.sender);
    }                                                                                                                                                                                                                                                                           

    function getMyUserData() 
    public view userIsFound(msg.sender) 
    returns (User memory)  {
        User memory user = users[msg.sender];
        return user;
    }

    function getOtherUserData(address userAddr) 
    public view userIsFound(userAddr) 
    returns (User memory) {
        User memory user = users[userAddr];
        return user;
    }
}
