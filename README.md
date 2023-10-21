# Staker

## Step 1: Install Dependencies

To get started, you'll need to install project dependencies using Yarn.
```bash
yarn
```
## Step 2: Configure Environment Variables

Before running tests and deploying scripts, you need to configure your environment variables. Create a .env.example file in the root directory of your project and set the following variables:

MNEMONICS: Your Ethereum wallet mnemonic phrase.
ETHERSCAN_API_KEY: Your Etherscan API key.
INFURA_OR_ALCHEMY_API_KEYS: Your Infura or Alchemy API keys.
NETWORK_BASE_FEE: The base fee for the network.
FORKING_NETWORK: The network you want to fork (should be set to "main").

Make sure to replace the placeholders with your actual values. Also, ensure you keep this file secure and do not commit it to version control.

## Step 3: Run Tests
```shell
yarn test test/Stakings.test.ts
```
## Step 4: Deploy
npx hardhat run scripts/${filename} --network ${network}

Replace ${filename} with the actual filename for your deployment script and ${network} with the desired network name for deployment (e.g., "hardhat" for local development or "main" for the Ethereum mainnet).

