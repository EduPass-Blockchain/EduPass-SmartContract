// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "contracts/RoleManager.sol";
import "contracts/UserManager.sol";

contract CertificateContract is ERC721URIStorage {
    RoleManagerContract roleManager;
    UserManagerContract userManager;

    struct UserToken {
        uint256 tokenId;
        bool isPublic;
    }
    
    uint256 private _nextTokenId;
    mapping(address => UserToken[]) private listOfUsersToken;

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

    function createCertificate(address userAddr, string memory tokenURI) 
    public onlyRole(RoleManagerContract.RoleType.ADMIN)
    returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(userAddr, tokenId);
        _setTokenURI(tokenId, tokenURI);

        UserToken memory newToken = UserToken(tokenId,false);
        listOfUsersToken[userAddr].push(newToken);        

        return tokenId;
    }

    function listAllCertificatesOfUser(address userAddr)
    public view returns(string[] memory) {
        UserToken[] memory listToken = listOfUsersToken[userAddr];
        string[] memory tokenUriArray = new string[](listToken.length);
        uint256 idx = 0;
        for (uint256 i = 0; i < listToken.length; i++) {
            if ((userAddr == msg.sender && !listToken[i].isPublic) || roleManager.isCurrentUserAdmin() || listToken[i].isPublic)
                tokenUriArray[idx++] = tokenURI(listToken[i].tokenId);
        }
        return tokenUriArray;
    }
}