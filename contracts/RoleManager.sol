// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "constants/Errors.const.sol";

contract RoleManagerContract {
    enum RoleType {ADMIN, ORGANIZATION, STUDENT}

    mapping(address => RoleType) private userRoles;

    constructor() {
        userRoles[msg.sender] = RoleType.ADMIN;
    }

    modifier onlyRole(RoleType role) {
        require(getRole() == role, ErrorCodes.ERROR_UNAUTHORIZED);
        _;
    }

    function isCurrentUserAdmin() 
    public view 
    returns(bool) {
        if (getRole() == RoleType.ADMIN)
            return true;
        return false;
    }

    function setAdminRole(address userAddr) public onlyRole(RoleType.ADMIN) {
        userRoles[userAddr] = RoleType.ADMIN;
    }

    function setOrganizationRole(address userAddr) public onlyRole(RoleType.ADMIN) {
        userRoles[userAddr] = RoleType.ORGANIZATION;
    }

    function setStudentRole(address userAddr) public onlyRole(RoleType.ADMIN) {
        userRoles[userAddr] = RoleType.STUDENT;
    }

    function getRole() public view returns(RoleType) {
        return userRoles[msg.sender];
    }
}