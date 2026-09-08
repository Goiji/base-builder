// Generates a merkle root + proofs for a token airdrop.
// Usage: node tooling/generate-merkle.mjs
import { createHash } from 'node:crypto';

const keccak = (hex) => createHash('sha3-256').update(Buffer.from(hex, 'hex')).digest('hex');

function pair(a, b) {
  return a < b ? keccak(a + b) : keccak(b + a);
}

function buildTree(leaves) {
  if (leaves.length === 1) return leaves;
  const next = [];
  for (let i = 0; i < leaves.length; i += 2) {
    if (i + 1 < leaves.length) next.push(pair(leaves[i], leaves[i + 1]));
    else next.push(leaves[i]);
  }
  return buildTree(next);
}

const entries = [
  ['0x00000000000000000000000000000000000000Aa', '1000000000000000000000'],
  ['0x00000000000000000000000000000000000000Bb', '2000000000000000000000'],
];

const leaves = entries.map(([addr, amt]) => keccak(Buffer.from(addr.slice(2).padStart(64, '0') + amt.slice(2).padStart(64, '0'), 'hex')));
const root = buildTree(leaves)[0];
console.log('MERKLE_ROOT=0x' + root);
