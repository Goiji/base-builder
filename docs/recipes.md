# Recipes

Common deployment patterns assembled from the primitives.

## Community token

1. Deploy `BaseERC20` with a max supply.
2. Mint the community allocation into a `RewardVault`.
3. Gate perks with `Allowlist`.

## NFT drop

1. Deploy `BaseERC721` with `mintPrice` and `maxSupply`.
2. Use `WhitelistSale` to gate the first phase.
3. Point `setBaseURI` at your metadata host.

## Airdrop

1. Build the merkle root offline (`npm run merkle`).
2. Deploy `MerkleAirdrop` and fund it.
3. Users claim with their proof.
