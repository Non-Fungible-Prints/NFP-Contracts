// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import {DataTypes} from "./DataTypes.sol";

interface ERC721Interface {
    function ownerOf(uint256 _tokenId) external view returns (address);
    function name() external view returns (string memory);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}

contract NFP is Ownable {
    mapping(string => DataTypes.NFTInfo) public nfcsRegistered;
    uint public printingCost = 0.0001 ether;

    using Counters for Counters.Counter;
    Counters.Counter private _nfcId;

    event NFCPrinted(string nfcTag, DataTypes.NFTInfo nftInfo, address nftOwnerAddress);
    event NFCStatusChanged(string nfcTag, DataTypes.NFTInfo nftInfo);
    event NFCDestroyed(string nfcTag, DataTypes.NFTInfo nftInfo);
    event NFCPriceChanged(uint newPrice, uint256 updateTime);

    constructor() {
    }

    modifier isOwnerOfNft(address _nftAddress, uint256 _nftId) {
        ERC721Interface collectionToCheck = ERC721Interface(_nftAddress);
        require(collectionToCheck.ownerOf(_nftId) == msg.sender, "You are not the owner of the NFT");
        _;
    }

    function withdraw() public onlyOwner {
        uint amount = address(this).balance;
        address platformOwner = owner();

        (bool success, ) = platformOwner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function printNFC(address _nftAddress, uint256 _nftId)
        public payable isOwnerOfNft(_nftAddress, _nftId)
    {
        require(msg.value >= printingCost, "Value is not correct"); 
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
        emit NFCPrinted(nfcTag, newNFT, msg.sender);
        _nfcId.increment();
    }

    function getNFCStatus(string memory _nfcTag) public view returns(bool) {
        return nfcsRegistered[_nfcTag].isActive;
    }

    function changeNFCState(string memory _nfcTag, address _nftAddress, uint256 _nftId)
        public isOwnerOfNft(_nftAddress, _nftId) {
            require(nfcsRegistered[_nfcTag].isDestroyed == false, "NFC is destroyed");
            bool currentNFCState = nfcsRegistered[_nfcTag].isActive;
            
            if (currentNFCState == true) {
                nfcsRegistered[_nfcTag].isActive = false;
            }

            if (currentNFCState == false) {
                nfcsRegistered[_nfcTag].isActive = true;
            }
            
            nfcsRegistered[_nfcTag].lastUpdated = block.timestamp;
            emit NFCStatusChanged(_nfcTag, nfcsRegistered[_nfcTag]);
        }

    function destroyNFC(string memory _nfcTag, address _nftAddress, uint256 _nftId)
        public isOwnerOfNft(_nftAddress, _nftId) {
            if (nfcsRegistered[_nfcTag].isDestroyed == true) {
                revert("NFC already destroyed!");
            }
            nfcsRegistered[_nfcTag].isDestroyed = false;
            nfcsRegistered[_nfcTag].lastUpdated = block.timestamp;
            emit NFCDestroyed(_nfcTag, nfcsRegistered[_nfcTag]);
        }

        function setPrintingCost(uint _newPritingCost) public onlyOwner {
            printingCost = _newPritingCost;
            emit NFCPriceChanged(printingCost, block.timestamp);
        }
}