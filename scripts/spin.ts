import { ethers } from "hardhat";

async function main() {
  const prizeWheelAddress = "YOUR_DEPLOYED_CONTRACT_ADDRESS"; // Replace with your deployed address
  const PrizeWheel = await ethers.getContractFactory("PrizeWheel");
  const prizeWheel = PrizeWheel.attach(prizeWheelAddress);

  // If spin() is payable, send value as needed (e.g., { value: ethers.parseEther("0.01") })
  const tx = await prizeWheel.spin();
  const receipt = await tx.wait();

  console.log("Spin transaction hash:", receipt.hash);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
