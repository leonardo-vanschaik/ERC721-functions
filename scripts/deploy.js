
const { ethers } = require("hardhat");

async function main() {
  const JohnnyFlexxxCollection = await ethers.getContractFactory("JohnnyFlexxxCollection");
  const johnnyFlexxxCollection = await JohnnyFlexxxCollection.deploy("JohnntFlexxxCollection", "JFLX");

  await johnnyFlexxxCollection.deployed();
  console.log("Success! Contract was deployed to: ", johnnyFlexxxCollection.address);

  await johnnyFlexxxCollection.mint("https://ipfs.io/ipfs/QmbLPeehtczfk2my81TJC1p2V3gG5ULYtdxhAVsWgjpjtb")
  console.log("NFT successfully minted")
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
