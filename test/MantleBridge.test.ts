/* eslint-disable */

import {
  impersonateAccount,
  setBalance,
  setNextBlockBaseFeePerGas,
  mine,
} from '@nomicfoundation/hardhat-network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

import {
  ERC20__factory,
  ERC20,
  IERC721,
  IERC721__factory,
  MantleBridge,
  MantleBridge__factory,
} from '../typechain-types';

import { JsonRpcProvider } from '@ethersproject/providers';
import { Signer } from 'ethers';

const IMPERSONATE_ADDRESS = '0x27bAe2Ba2CDF965e8f8E2a8846f41f2858CD963A';
const MNT = '0x3c3a81e81dc49A522A592e7622A7E711c06bf354';

async function getErc20(impersonatedSigner: Signer, address: string) {
  return new ethers.Contract(address, ERC20__factory.abi, impersonatedSigner);
}
async function getErc721(impersonatedSigner: Signer, address: string) {
  return new ethers.Contract(address, IERC721__factory.abi, impersonatedSigner);
}
describe('Mantle Bridge', function () {
  let impersonatedSigner: Signer;
  let mantleBridge: MantleBridge;
  let provider: JsonRpcProvider;

  beforeEach(async () => {
    await impersonateAccount(IMPERSONATE_ADDRESS);

    setBalance(IMPERSONATE_ADDRESS, 1000 * 10 ** 18);

    impersonatedSigner = await ethers.getSigner(IMPERSONATE_ADDRESS);
    provider = ethers.provider;

    mantleBridge = await new MantleBridge__factory(impersonatedSigner).deploy();

    await mantleBridge.initialize();
  });

  it('Allows deposit eth => receive lp <cbEth, weth>', async function () {
    this.timeout(160000);
    const mntErc20 = await getErc20(impersonatedSigner, MNT);

    const depositAmount = '0.5';

    setNextBlockBaseFeePerGas(0);

    const depositTx = {
      to: mantleBridge.address,
      value: ethers.utils.parseEther(depositAmount),
    };

    await impersonatedSigner.sendTransaction(depositTx);

   
  });
});
