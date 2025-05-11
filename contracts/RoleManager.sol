// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "constants/Errors.const.sol";

contract RoleManagerContract {
    enum RoleType {ADMIN, ORGANIZATION, STUDENT}

    mapping(address => RoleType) private userRoles;

    constructor() {
        userRoles[msg.sender] = RoleType.ADMIN;
    }

    modifier onlyRole(RoleType role, address userAddr) {
        require(getRole(userAddr) == role, ErrorCodes.ERROR_UNAUTHORIZED);
        _;
    }

    function setAdminRole(address userAddr) public onlyRole(RoleType.ADMIN, msg.sender) {
        userRoles[userAddr] = RoleType.ADMIN;
    }

    function setOrganizationRole(address userAddr) public onlyRole(RoleType.ADMIN, msg.sender) {
        userRoles[userAddr] = RoleType.ORGANIZATION;
    }

    function setStudentRole(address userAddr) public onlyRole(RoleType.ADMIN, msg.sender) {
        userRoles[userAddr] = RoleType.STUDENT;
    }

    function getRole(address userAddr) public view returns(RoleType) {
        return userRoles[userAddr];
    }
}