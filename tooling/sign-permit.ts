// Example: build an EIP-712 permit signature off-chain.
import { ethers } from 'ethers';

export interface Permit {
  owner: string;
  spender: string;
  value: bigint;
  nonce: bigint;
  deadline: bigint;
}

const TYPES = {
  Permit: [
    { name: 'owner', type: 'address' },
    { name: 'spender', type: 'address' },
    { name: 'value', type: 'uint256' },
    { name: 'nonce', type: 'uint256' },
    { name: 'deadline', type: 'uint256' },
  ],
};

export async function signPermit(
  signer: ethers.Signer,
  chainId: number,
  token: string,
  permit: Permit,
): Promise<string> {
  const domain = {
    name: 'PermitERC20',
    version: '1',
    chainId,
    verifyingContract: token,
  };
  return signer.signTypedData(domain, TYPES, permit);
}
