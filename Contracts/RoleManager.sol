// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "Constants/Errors.const.sol";

contract RoleManager {
    enum RoleType {ADMIN, ORGANIZATION, STUDENT}

    mapping(address => RoleType) private userRoles;

    constructor() {
        userRoles[msg.sender] = RoleType.ADMIN;
    }

    function isAdmin(address userAddr) public view returns(bool) {
        if (userRoles[userAddr] == RoleType.ADMIN)
            return true;
        return false;
    }

    function isOrganization(address userAddr) public view returns(bool) {
        if (userRoles[userAddr] == RoleType.ORGANIZATION)
            return true;
        return false;
    }

    function isStudent(address userAddr) public view returns(bool) {
        if (userRoles[userAddr] == RoleType.STUDENT)
            return true;
        return false;
    }

    modifier onlyRole(RoleType role) {
        require(userRoles[msg.sender] == role, ErrorCodes.ERROR_UNAUTHORIZED);
        _;
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