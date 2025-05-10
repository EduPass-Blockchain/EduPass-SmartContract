// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "Contracts/RoleManager.sol";

contract CertificateContract is ERC721URIStorage {
    RoleManagerContract roleManager;
    uint256 private _nextTokenId;

    constructor(address _roleManagerAddress) ERC721("EduPassCertificate", "EPC") {
        roleManager = RoleManagerContract(_roleManagerAddress);
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

        return tokenId;
    }
}