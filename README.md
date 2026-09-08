# base-builder

Open toolkit for building and deploying EVM smart contracts on **Base**.

Built in the open, one commit at a time.

## What's inside

- **Token templates** — ERC20 / ERC721 / ERC1155, incl. permit, burn-fee and metadata variants.
- **Distribution primitives** — merkle airdrops, vesting and payment splitting.
- **Governance & access** — timelock, multisig, allowlists and whitelist sales.
- **Factory** — CREATE2 + EIP-1167 clone deployers with on-chain registries.
- **Financial** — linear bonding-curve market, staking and crowdfund pool.
- **Tooling** — Foundry + Hardhat deploy targets for Base and Base Sepolia.

## Layout

```
src/          Solidity contracts
interfaces/   Shared Solidity interfaces
libraries/    Internal math, address & crypto helpers
lib/          Vendor libraries (forge install)
test/         Foundry test suite
script/       Deployment scripts
tooling/      Off-chain helper tools
```

## Getting started

```bash
forge install foundry-rs/forge-std
forge build
forge test
```

## Security

See [SECURITY.md](SECURITY.md). Everything under `src/`, `libraries/` and
`interfaces/` is unaudited reference material unless stated otherwise.
