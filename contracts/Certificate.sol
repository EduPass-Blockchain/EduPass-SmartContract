// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "contracts/RoleManager.sol";
import "contracts/UserManager.sol";
import "constants/Errors.const.sol";

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
        require(roleManager.getRole(msg.sender) == role, ErrorCodes.ERROR_UNAUTHORIZED);
        _;
    }

    modifier isOwner(address userAddr, string memory userTokenUri) {
        bool isAvailable = false;
        UserToken[] memory listToken = listOfUsersToken[userAddr];
        for (uint256 i = 0; i < listToken.length; i++) {
            if (keccak256(abi.encodePacked(tokenURI(listToken[i].tokenId))) == keccak256(abi.encodePacked(userTokenUri))) {
                isAvailable = true;
                break;
            }
        }
        require(isAvailable == true, ErrorCodes.ERROR_UNAUTHORIZED);
        _;
    }

    function createCertificate(address userAddr, string memory tokenURI) 
    public onlyRole(RoleManagerContract.RoleType.ORGANIZATION)
    returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(userAddr, tokenId);
        _setTokenURI(tokenId, tokenURI);

        UserToken memory newToken = UserToken(tokenId,false);
        listOfUsersToken[userAddr].push(newToken);        

        return tokenId;
    }

    function listAllCertificatesOfUser(address userAddr)
    public view returns(string[][] memory) {
        UserToken[] memory listToken = listOfUsersToken[userAddr];
        string[][] memory tokenUriArray = new string[][](listToken.length);
        uint256 idx = 0;
        for (uint256 i = 0; i < listToken.length; i++) {
            if ((userAddr == msg.sender && !listToken[i].isPublic) || roleManager.getRole(msg.sender) == RoleManagerContract.RoleType.ADMIN || listToken[i].isPublic) {
                string[] memory entry = new string[](2);
                entry[0] = tokenURI(listToken[i].tokenId);
                entry[1] = listToken[i].isPublic ? "1" : "0";
                tokenUriArray[idx++] = entry;
            }
        }
        
        string[][] memory trimmed = new string[][](idx);
        for (uint256 i = 0; i < idx; i++) {
            trimmed[i] = tokenUriArray[i];
        }
        return trimmed;
    }

    function setCertificatePublic(string memory userTokenUri)
    public isOwner(msg.sender, userTokenUri) {
        UserToken[] storage listToken = listOfUsersToken[msg.sender];
        for (uint256 i = 0; i < listToken.length; i++) {
            if (
                keccak256(abi.encodePacked(tokenURI(listToken[i].tokenId))) ==
                keccak256(abi.encodePacked(userTokenUri))
            ) {
                listToken[i].isPublic = true;
                break;
            }
        }
    }

    function setCertificatePrivate(string memory userTokenUri)
    public isOwner(msg.sender, userTokenUri) {
        UserToken[] storage listToken = listOfUsersToken[msg.sender];
        for (uint256 i = 0; i < listToken.length; i++) {
            if (
                keccak256(abi.encodePacked(tokenURI(listToken[i].tokenId))) ==
                keccak256(abi.encodePacked(userTokenUri))
            ) {
                listToken[i].isPublic = false;
                break;
            }
        }
    }
} 