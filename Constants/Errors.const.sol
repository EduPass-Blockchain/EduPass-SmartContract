// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ErrorCodes {
    // User errors
    string public constant ERROR_USER_IS_NOT_FOUND = "USER_IS_NOT_FOUND";
    string public constant ERROR_USER_IS_CREATED = "USER_IS_CREATED";

    // Authorized errors
    string public constant ERROR_UNAUTHORIZED = "UNAUTHORIZED";
}