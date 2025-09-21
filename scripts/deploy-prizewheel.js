// scripts/deploy-prizewheel.js
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying PrizeWheel with account:", deployer.address);

    const mockEntropyAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // replace if different

    const PrizeWheel = await ethers.getContractFactory("PrizeWheel");
    const prizeWheel = await PrizeWheel.deploy(mockEntropyAddress);

    // Hardhat + ethers v6 automatically waits for deployment, no .deployed() needed
    console.log("PrizeWheel deployed at:", prizeWheel.target); // use .target in v6
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
