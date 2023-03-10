#!/bin/sh

atticd &

sleep 1

TOKEN=$(atticadm make-token \
  --sub test \
  --validity 1y \
  --pull "*" \
  --push "*" \
  --create-cache "*" \
  --configure-cache "*" \
  --configure-cache-retention "*" \
)
attic login local http://localhost:8080 "$TOKEN"
attic cache create test
attic watch-store test &

# nix build --impure --max-jobs auto
