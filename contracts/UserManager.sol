// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "constants/Errors.const.sol";
import "contracts/RoleManager.sol";

contract UserManagerContract {
    RoleManagerContract roleManager;
    enum Gender { Male, Female, Other }

    struct User {
        string fullName;
        uint256 dateOfBirth;
        Gender gender;
    }

    mapping(address => User) private users;

    constructor(address _roleManagerAddress) {
        roleManager = RoleManagerContract(_roleManagerAddress);
        
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

    modifier onlyRole(RoleManagerContract.RoleType role) {
        require(roleManager.getRole(msg.sender) == role, ErrorCodes.ERROR_UNAUTHORIZED);
        _;
    }

    function createUser(string memory _fullName, uint256 _dateOfBirth, Gender _gender) 
    public userIsNotCreated(msg.sender) {
        users[msg.sender] = User(_fullName, _dateOfBirth, _gender);
        roleManager.setStudentRole(msg.sender);
    }                                                                                                                                                                                                                                                                           

    function getCurrentUserData() 
    public view userIsFound(msg.sender) 
    returns (string memory, uint256, Gender)  {
        User memory user = users[msg.sender];
        return (user.fullName, user.dateOfBirth, user.gender);
    }

    function getOtherUserData(address userAddr) 
    public view userIsFound(userAddr) 
    returns (string memory, uint256, Gender) {
        User memory user = users[userAddr];
        return (user.fullName, user.dateOfBirth, user.gender);
    }
}
