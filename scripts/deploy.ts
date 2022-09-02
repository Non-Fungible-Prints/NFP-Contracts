import { ethers } from "hardhat";

async function main() {
  const NFP = await ethers.getContractFactory("NFP");
  const NFPContract = await NFP.deploy();

  await NFPContract.deployed();

  console.log("NFP deployed to:", NFPContract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
