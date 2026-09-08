# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [1.0.0] - 2026-09-08

### Added

- Token templates: `BaseERC20`, `BaseERC721`, `BaseERC1155`, `PermitERC20`,
  `BuybackERC20`, `BaseERC721Metadata`.
- Distribution primitives: `TokenVesting`, `MerkleAirdrop`, `PaymentSplitter`.
- CREATE2 `BaseTokenFactory`, EIP-1167 `CloneFactory`, `ContractRegistry`.
- Governance & access: `Timelock`, `MultisigWallet`, `SnapshotRegistry`,
  `Allowlist`, `WhitelistSale`.
- Market & treasury: `BondingCurve`, `Staking`, `RewardVault`, `Crowdfund`.
- Library helpers for math, percentages, addresses, bytes and signatures.
- Foundry test suite, forge deploy scripts and offline tooling.
- CI workflows for tests, linting and gas snapshots.
