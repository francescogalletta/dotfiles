#!/usr/bin/env bash
# Snapshot the ZSA Voyager layout from Oryx into git-versioned JSON.
# Run after saving changes in Oryx, then commit the diff.
set -euo pipefail

# Must match the layout actually flashed to the board — check with
# `kontroll status`, which prints firmware as <layoutId>/<revisionId>.
LAYOUT_ID="JmV6W"
DIR="$(cd "$(dirname "$0")" && pwd)"

curl -fsS -X POST https://oryx.zsa.io/graphql \
  -H 'Content-Type: application/json' \
  -d "{\"query\":\"query getLayout(\$hashId: String!, \$revisionId: String!) { layout(hashId: \$hashId, revisionId: \$revisionId) { title revision { hashId title layers { position title keys } } } }\",\"variables\":{\"hashId\":\"$LAYOUT_ID\",\"revisionId\":\"latest\"}}" \
  | jq . > "$DIR/layout.json"

echo "Snapshotted layout $LAYOUT_ID (revision $(jq -r '.data.layout.revision.hashId' "$DIR/layout.json"))"
git -C "$DIR" --no-pager diff --stat -- layout.json
