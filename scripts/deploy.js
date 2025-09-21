async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  const MockEntropyV2 = await ethers.getContractFactory('MockEntropyV2');
  const mockEntropy = await MockEntropyV2.deploy();
  console.log('MockEntropyV2 deployed to:', mockEntropy.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
