# Market & treasury modules

## BondingCurve

Linear bonding-curve market priced by the integral of a base fee plus a
slope-per-supply term. Buying adds reserve-backed supply; selling redeems it.

## Staking

Stake an ERC20 and accrue a second ERC20 at a fixed per-second rate.

## RewardVault

Hold reward tokens and let the owner drip or sweep balances.

## Crowdfund

Time-boxed ETH pool with goal tracking, owner close/withdraw and a refund
window for backers when the goal is not reached.
