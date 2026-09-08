# base-builder

![License](https://img.shields.io/badge/license-MIT-blue)
![Solidity](https://img.shields.io/badge/solidity-%5E0.8.20-informational)

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
test/         Foundry test suite
script/       Deployment scripts
tooling/      Off-chain helper tools
docs/         Module documentation
```

## Getting started

```bash
forge install foundry-rs/forge-std
forge build
forge test
```

## Modules

- [Token templates](docs/tokens.md)
- [Distribution](docs/distribution.md)
- [Factory & registry](docs/factory.md)
- [Governance & access](docs/governance.md)
- [Market & treasury](docs/markets.md)
- [Libraries](docs/libraries.md)
- [Architecture](docs/architecture.md)

## Security

See [SECURITY.md](SECURITY.md). Everything under `src/`, `libraries/` and
`interfaces/` is unaudited reference material unless stated otherwise.

## License

MIT. See [LICENSE](LICENSE).
