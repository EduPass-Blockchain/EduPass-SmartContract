// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "contracts/RoleManager.sol";
import "contracts/UserManager.sol";

contract CertificateContract is ERC721URIStorage {
    RoleManagerContract roleManager;
    UserManagerContract userManager;

    uint256 private _nextTokenId;

    constructor(
        address _roleManagerAddress,
        address _userManagerAddress
    ) ERC721("EduPassCertificate", "EPC") {
        roleManager = RoleManagerContract(_roleManagerAddress);
        userManager = UserManagerContract(_userManagerAddress);
    }

    modifier onlyRole(RoleManagerContract.RoleType role) {
        require(roleManager.getRole() == role, ErrorCodes.ERROR_UNAUTHORIZED);
        _;
    }

    function awardItem(address userAddr, string memory tokenURI) 
    public onlyRole(RoleManagerContract.RoleType.ADMIN)
    returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(userAddr, tokenId);
        _setTokenURI(tokenId, tokenURI);

        userManager.addNftToUser(userAddr, tokenId);

        return tokenId;
    }
}