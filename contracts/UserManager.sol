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

    struct UserToken {
        uint256 tokenId;
        bool isPublic;
    }

    mapping(address => User) private users;
    mapping(address => UserToken[]) private listOfUsersToken;

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
        require(roleManager.getRole() == role, ErrorCodes.ERROR_UNAUTHORIZED);
        _;
    }

    // User functions
    function createUser(string memory _fullName, uint256 _dateOfBirth, Gender _gender) 
    public userIsNotCreated(msg.sender) {
        users[msg.sender] = User(_fullName, _dateOfBirth, _gender);
        roleManager.setStudentRole(msg.sender);
    }                                                                                                                                                                                                                                                                           

    function getCurrentUserData() 
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

    // NFT functions
    function addNftToUser(address userAddr, uint256 tokenId) 
    public onlyRole(RoleManagerContract.RoleType.ADMIN) {
        UserToken memory newToken = UserToken(tokenId,false);
        listOfUsersToken[userAddr].push(newToken);
    }

    function listAllNftsOfUser(address userAddr)
    public view returns(uint256[] memory) {
        UserToken[] memory listToken = listOfUsersToken[userAddr];
        uint256[] memory tokenIdArray = new uint256[](listToken.length);
        uint256 idx = 0;
        for (uint256 i = 0; i < listToken.length; i++) {
            if ((userAddr == msg.sender && !listToken[i].isPublic) || roleManager.isCurrentUserAdmin() || listToken[i].isPublic)
                tokenIdArray[idx++] = listToken[i].tokenId;
        }
        return tokenIdArray;
    }
}
