<h1>
<p align="center">
  <br>Non Fungible Prints
</h1>
  <p align="center">
    Your digital asset in Physical World
    <br />
    </p>
</p>
</br>
</br>

## About The Project

Non Fungible Prints is a platform that turns any kind of NFT into a physical object, which can be either a key ring or a figure. Every objects that represents the NFT token, has also printed NFC chip on it, which stores info about the NFT, and later on can work as a physical token for identification.

The platform works in the following way:

1. User connects wallet to the dapp
2. Available NFT tokens on the given account are displayed in the dashboard, and user is able to place an order to "print" physical representation of the given NFT
3. User selects the form of the print (key ring or figure)
4. User pays for the service, printing, and the shipping costs
5. Once the physical token is ready, user can set it's status as active or inactive
6. State of the physical token can be then verified by anyone, on the dedicated app
7. Token can be sold with the NFT or kept, but only the owner of the NFT can change it's state
## Tech stack

The smart contracts are built with Solidity and deployed to the Polygon Mumbai network. The Graph is used to query the data from the smart contract, so that anyone can verify the physical token, without a need to connect wallet.

### Built With

- [Hardhat](https://hardhat.org/)
- [Solidity](https://docs.soliditylang.org/en/v0.8.11/)
- [Alchemy](https://www.alchemy.com/)
- [React](https://reactjs.org/)

### Prerequisites

- [Node.js](https://nodejs.org/en/download/)
- [Metmask](https://metamask.io/)

### Installation

1. Install all the dependencies - `yarn`

2. Create an account on Alchemy, then create a new app and select "Polygon Mumbai" as a network.

3. Create a `.env` file in the root folder and add the
   following variables:

```
   API_URL=<ALCHEMY_API_URL>
   API_KEY=<THE_LAST_PART OF_THE_API_URL>
   PRIVATE_KEY=<YOUR_WALLET'S_PRIVATE_KEY>
   CONTRACT_ADDRESS=<DEPOLOYED_TOKEN_ADDRESS>
   POLYGONSCAN_API_KEY=<POLYGONSCAN_API_KEY>
```

Hint: You can get your own API key in the alchemy dashboard. The last part can be added after deploying the token.

### Compiling the Contract

run `npx hardhat compile` command.

### Deploying Smart Contract

1. Run `npx hardhat run scripts/deploy.ts --network mumbai` command, to deploy Non Fungible Prints contract
2. Run `npx hardhat verify "<NFP_Contract_Address>" --network mumbai` command, to verify Non Fungible Prints contract