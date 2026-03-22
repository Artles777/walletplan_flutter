#!/usr/bin/env bash

set -euo pipefail

echo "==> Running initial code generation"
dart run build_runner build --delete-conflicting-outputs

echo "==> Starting code generation watcher"
exec dart run build_runner watch --delete-conflicting-outputs
