import { ethers, upgrades } from 'hardhat';
import * as hre from 'hardhat';

const func = async () => {
  const { deployer } = await hre.getNamedAccounts();
  const owner = await hre.ethers.getSigner(deployer);

  const mantleBridgeFactory = await ethers.getContractFactory(
    'MantleBridge',
    owner,
  );
  const mantleBridgeContract = await upgrades.deployProxy(
    mantleBridgeFactory,
    [],
  );

  await mantleBridgeContract.deployed();

  console.log('mantleBridge deployed to:', mantleBridgeContract.address);
};

func();
