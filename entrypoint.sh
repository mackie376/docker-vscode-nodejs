#!/usr/bin/env bash

set -e

WORKSPACE_DIR="${HOME}/workspace"

if [[ -s "${HOME}/workspace/package.json" ]]; then
  cd "${HOME}/workspace"
  npm install
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- npm run "$@"
fi

exec "$@"
