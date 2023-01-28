/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: {
        version: "0.8.9",
        defaultNetwork: "goerli",
        networks: {
            hardhat: {},
            goerli: {
                url: "https://rpc.ankr.com/eth_goerli", // from https://www.ankr.com/rpc/eth/eth_goerli/
                accounts: [`0x${process.env.PRIVATE_KEY}`], //array of accounts
                // this is the account which we are going to use to deploy our smart contract
            },
        },
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
};

// to properly deploy our contract
// before that .. we have to have meta mask wallet

// we store that key inside environment variable
// we can use our private key to connect to the girly network .

// we can start connecting to our network.
