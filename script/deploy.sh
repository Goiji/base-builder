#!/usr/bin/env bash
set -euo pipefail

# Usage: ./script/deploy.sh <DeployContract> [rpc_env_var]
TARGET="${1:?pass a deploy script, e.g. DeployAirdrop}"
RPC_VAR="${2:-BASE_SEPOLIA_RPC}"

set -a
# shellcheck source=/dev/null
[ -f .env ] && source .env
set +a

forge script "script/${TARGET}.s.sol" --rpc-url "${!RPC_VAR}" --broadcast
