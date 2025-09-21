const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying MockEntropyV2 with account:", deployer.address);

    const MockEntropy = await hre.ethers.getContractFactory("MockEntropyV2");
    const mockEntropy = await MockEntropy.deploy();

    await mockEntropy.waitForDeployment(); // ethers v6
    console.log("MockEntropyV2 deployed at:", mockEntropy.target);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
