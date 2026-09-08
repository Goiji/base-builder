# base-builder

Open toolkit for building and deploying EVM smart contracts on **Base**.

Built in the open, one commit at a time.

## What's inside

- **Token templates** — audited-style ERC20, ERC721 and ERC1155 primitives.
- **Distribution primitives** — merkle airdrops, vesting and payment splitting.
- **Factory** — CREATE2 deployment with a persistent on-chain registry.
- **Tooling** — Foundry + Hardhat scripts for Base and Base Sepolia.

## Layout

```
src/          Solidity contracts
interfaces/   Shared Solidity interfaces
libraries/    Internal math & helpers
test/         Foundry + Hardhat tests
script/       Deployment scripts
```

## Getting started

```bash
forge build
forge test
```
