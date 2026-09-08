# Factory & registry

## BaseTokenFactory

Deterministic (CREATE2) deployment of `BaseERC20`. Every deployment is
recorded in an on-chain registry keyed by salt, and future addresses can
be predicted before deploying.

## ContractRegistry

Access-controlled registry mapping friendly names to contract addresses.
