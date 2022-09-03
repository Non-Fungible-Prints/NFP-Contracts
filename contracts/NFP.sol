// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import {DataTypes} from "./DataTypes.sol";

interface ERC721Interface {
    function ownerOf(uint256 _tokenId) external view returns (address);
    function name() external view returns (string memory);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}

contract NFP {
    mapping(string => DataTypes.NFTInfo) public nfcsRegistered;

    using Counters for Counters.Counter;
    Counters.Counter private _nfcId;

    event NFCPrinted(string nfcTag, DataTypes.NFTInfo nftInfo);
    event NFCStatusChanged(string nfcTag, DataTypes.NFTInfo nftInfo);

    constructor() {
    }

    modifier isOwnerOfNft(address _nftAddress, uint256 _nftId) {
        ERC721Interface collectionToCheck = ERC721Interface(_nftAddress);
        require(collectionToCheck.ownerOf(_nftId) == msg.sender, "You are not the owner of the NFT");
        _;
    }

    function printNFC(address _nftAddress, uint256 _nftId)
        public isOwnerOfNft(_nftAddress, _nftId)
    {
        ERC721Interface collectionToCheck = ERC721Interface(_nftAddress);
        uint256 newNfcId = _nfcId.current();
        string memory titleOfNft = collectionToCheck.name();
        string memory uriOfNft = collectionToCheck.tokenURI(_nftId);
        string memory nfcTag = string(abi.encodePacked(Strings.toString(newNfcId),"-",titleOfNft,"-",Strings.toString(_nftId)));
    
        DataTypes.NFTInfo memory newNFT = DataTypes.NFTInfo({
            nftAddress: _nftAddress,
            nftId: _nftId,
            isActive: false,
            isDestroyed: false,
            nftName: titleOfNft,
            nftUri: uriOfNft,
            lastUpdated: block.timestamp
        });
        nfcsRegistered[nfcTag] = newNFT;
        emit NFCPrinted(nfcTag, newNFT);
        _nfcId.increment();
    }

    function getNFCStatus(string memory _nfcTag) public view returns(bool) {
        return nfcsRegistered[_nfcTag].isActive;
    }

    function activateNFC(string memory _nfcTag, address _nftAddress, uint256 _nftId)
        public isOwnerOfNft(_nftAddress, _nftId) {
            if (nfcsRegistered[_nfcTag].isActive == true) {
                revert("NFC already activated!");
            }
            nfcsRegistered[_nfcTag].isActive = true;
            nfcsRegistered[_nfcTag].lastUpdated = block.timestamp;
            emit NFCStatusChanged(_nfcTag, nfcsRegistered[_nfcTag]);
        }

    function deactivateNFC(string memory _nfcTag, address _nftAddress, uint256 _nftId)
        public isOwnerOfNft(_nftAddress, _nftId) {
            if (nfcsRegistered[_nfcTag].isActive == false) {
                revert("NFC already deactivated!");
            }
            nfcsRegistered[_nfcTag].isActive = false;
            nfcsRegistered[_nfcTag].lastUpdated = block.timestamp;
            emit NFCStatusChanged(_nfcTag, nfcsRegistered[_nfcTag]);
        }
}