# Architecture

```
                 +----------------------+
  User  -------> |  Token templates     |  BaseERC20/721/1155
                 +----------------------+
                 |  Distribution        |  Vesting, Airdrop, Splitter
                 +----------------------+
                 |  Factory & Registry  |  CREATE2 deployer + index
                 +----------------------+
                 |  Governance / Vault  |  Timelock, RewardVault
                 +----------------------+
                 |  Market primitives   |  BondingCurve, Pair
                 +----------------------+
                        |  deploy
                        v
                  Base / Base Sepolia
```
