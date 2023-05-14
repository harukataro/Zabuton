/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require('hardhat-contract-sizer');
require("hardhat-gas-reporter");

module.exports = {
  solidity: "0.8.17",
  settings: { optimizer: { enabled: true, runs: 1 } },
  networks: {
    hardhat: {
      parallel: false,
      accounts: {
        count: 22, // Change if you want more wallet for test
      },
    },
    goerli: {
      url: process.env.ALC_GOERLI_URL,
      chainId: 5,
      accounts: [process.env.PRIVATE_KEY]
    },
    polygon: {
      url: process.env.ALC_POLYGON_URL,
      chainId: 137,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    //apiKey: process.env.POLYGONSCAN_API_KEY
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  gasReporter: {
    currency: 'JPY',
    enabled: true,
    token: 'ETH',
    gasPriceApi: "https://api.etherscan.io/api?module=proxy&action=eth_gasPrice",
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
  },
};

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});