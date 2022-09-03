// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.0;

library DataTypes {
    struct NFTInfo {
        address nftAddress;
        uint256 nftId;
        bool isActive;
        bool isDestroyed;
        string nftName;
        string nftUri;
        uint256 lastUpdated;
    }
}