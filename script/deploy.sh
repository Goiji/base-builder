#!/usr/bin/env bash
set -euo pipefail

# Usage: ./script/deploy.sh <DeployContract> [chain]
TARGET="${1:?pass a deploy script, e.g. DeployAirdrop}"
CHAIN="${2:-base-sepolia}"

set -a
# shellcheck source=/dev/null
[ -f .env ] && source .env
set +a

forge script "script/${TARGET}.s.sol" --rpc-url "${RPC_URL:?}" --broadcast
