#!/usr/bin/env bash

set -euo pipefail

nix build .
docker load < result
docker tag attic:latest paholg/attic:latest
docker push paholg/attic:latest
