#!/usr/bin/env bash
# Snapshot the ZSA Voyager layout from Oryx into git-versioned JSON.
# Run after saving changes in Oryx, then commit the diff.
set -euo pipefail

LAYOUT_ID="ZlBeJ"
DIR="$(cd "$(dirname "$0")" && pwd)"

curl -fsS -X POST https://oryx.zsa.io/graphql \
  -H 'Content-Type: application/json' \
  -d "{\"query\":\"query getLayout(\$hashId: String!, \$revisionId: String!) { layout(hashId: \$hashId, revisionId: \$revisionId) { title revision { hashId title layers { position title keys } } } }\",\"variables\":{\"hashId\":\"$LAYOUT_ID\",\"revisionId\":\"latest\"}}" \
  | jq . > "$DIR/layout.json"

echo "Snapshotted layout $LAYOUT_ID (revision $(jq -r '.data.layout.revision.hashId' "$DIR/layout.json"))"
git -C "$DIR" --no-pager diff --stat -- layout.json
