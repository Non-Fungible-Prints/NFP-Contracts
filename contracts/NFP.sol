// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {DataTypes} from "./DataTypes.sol";

contract NFP {

    mapping(string => DataTypes.NFTInfo) public nftsRegistered;

    constructor() {
    }

    function printNFT(string memory _nfcTag, address _nftAddress, uint256 _nftId)
        public
    {
        DataTypes.NFTInfo memory newNFT = DataTypes.NFTInfo({
            nftAddres: _nftAddress,
            nftId: _nftId,
            isActive: false
        });
        nftsRegistered[_nfcTag] = newNFT;
    }
}