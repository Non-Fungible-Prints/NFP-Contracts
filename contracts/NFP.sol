// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {DataTypes} from "./DataTypes.sol";

interface ERC721Interface {
    function ownerOf(uint256 _tokenId) external view returns (address);
}

contract NFP {
    mapping(string => DataTypes.NFTInfo) public nftsRegistered;

    constructor() {
    }

    modifier isOwnerOfNft(address _nftAddress, uint256 _nftId) {
        ERC721Interface collectionToCheck = ERC721Interface(_nftAddress);
        require(collectionToCheck.ownerOf(_nftId) == msg.sender, "You are not the owner of the NFT");
        _;
    }

    function printNFT(string memory _nfcTag, address _nftAddres, uint256 _nftId)
        public isOwnerOfNft(_nftAddres, _nftId)
    {
        DataTypes.NFTInfo memory newNFT = DataTypes.NFTInfo({
            nftAddres: _nftAddres,
            nftId: _nftId,
            isActive: false
        });
        nftsRegistered[_nfcTag] = newNFT;
    }
}