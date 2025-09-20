import { ethers } from "hardhat";

async function main() {
  const PrizeWheel = await ethers.getContractFactory("PrizeWheel");
  const pythEntropyAddress = "0x41c9e39574F40Ad34c79f1C99B66A45eFB830d4c"; // Base Sepolia Pyth Entropy Address
  const prizeWheel = await PrizeWheel.deploy(pythEntropyAddress);

  await prizeWheel.deployed();
  console.log("PrizeWheel deployed to:", prizeWheel.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
