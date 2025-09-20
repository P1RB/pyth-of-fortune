import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
// Import dotenv to load environment variables from a .env file
require('dotenv').config();

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    // Define the Base Sepolia testnet
    "base-sepolia": {
      url: 'https://sepolia.base.org', // Base Sepolia RPC URL
      accounts: [process.env.PRIVATE_KEY!], // Your wallet private key from .env file
      gasPrice: 1000000000, // 1 gwei (optional but can help with transaction pricing)
    },
    // Define Base Mainnet (for later)
    "base-mainnet": {
      url: 'https://mainnet.base.org',
      accounts: [process.env.PRIVATE_KEY!],
      gasPrice: 1000000000,
    },
  },
  // You can verify your contract on Basescan
  etherscan: {
    apiKey: {
      "base-sepolia": process.env.BASESCAN_API_KEY!,
      "base-mainnet": process.env.BASESCAN_API_KEY!,
    },
    customChains: [
      {
        network: "base-sepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org"
        }
      }
    ]
  },
};

export default config;