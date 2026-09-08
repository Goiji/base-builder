# Token templates

## BaseERC20

Mintable, burnable, pausable ERC20 with an optional hard supply cap.

- `mint(to, amount)` / `burn(from, amount)` — owner only
- `pause()` / `unpause()` — owner only
- Immutable `maxSupply` set at deployment

## BaseERC721

Enumerable, pausable NFT with public paid minting and owner free-mint.

- `publicMint(to)` — requires exact `mintPrice`
- `ownerMint(to)` — free
- `setBaseURI` / `pause` / `unpause`

## BaseERC1155

Multi-token standard with per-id supply tracking.

## Deploying

```bash
forge script script/DeployBaseERC20.s.sol --rpc-url $BASE_RPC --broadcast
```
