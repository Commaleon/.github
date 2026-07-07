#!/usr/bin/env sh
#
# distribute-forms.sh - copy the canonical issue-form templates from this repo
# into every active Commaleon service repo.
#
# Why: GitHub YAML issue forms do NOT cascade from the org ".github" repo the
# way config.yml does. Each repo needs its own copy in .github/ISSUE_TEMPLATE/.
# This repo is the single source of truth; run this script after editing a form
# to push the change everywhere.
#
# Usage:
#   ./distribute-forms.sh                 # push every *.yml to the default repo list
#   ./distribute-forms.sh pim purchase    # push to specific repos only
#
# Requirements:
#   - gh (GitHub CLI), authenticated (`gh auth login`)
#   - No jq (uses `gh --jq`)
#
# Behaviour: idempotent upsert (create, or update via sha). Safe to re-run.
#
set -eu

OWNER="${OWNER:-Commaleon}"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC_DIR="$SCRIPT_DIR/ISSUE_TEMPLATE"

# Active service repos where issues are actually filed. Edit as the org grows.
DEFAULT_REPOS="pim purchase shipment timer order fulfillment web customer-account inventory lead-generator ingestion changelog"

REPOS="$*"
[ -z "$REPOS" ] && REPOS="$DEFAULT_REPOS"

[ -d "$SRC_DIR" ] || { echo "error: $SRC_DIR not found" >&2; exit 1; }
command -v gh >/dev/null 2>&1 || { echo "error: gh (GitHub CLI) not found" >&2; exit 1; }

b64() { base64 < "$1" | tr -d '\n'; }

put() { # repo file
  _repo="$1"; _file="$2"; _name=$(basename "$_file")
  _path=".github/ISSUE_TEMPLATE/$_name"
  _content=$(b64 "$_file")
  _sha=$(gh api "repos/$OWNER/$_repo/contents/$_path" --jq '.sha' 2>/dev/null || true)
  if [ -n "${_sha:-}" ] && [ "$_sha" != "null" ]; then
    if gh api --method PUT "repos/$OWNER/$_repo/contents/$_path" \
         -f message="chore: sync issue form ($_name)" -f content="$_content" -f sha="$_sha" >/dev/null 2>&1; then
      echo "  updated $_name"
    else echo "  FAILED  $_name" >&2; fi
  else
    if gh api --method PUT "repos/$OWNER/$_repo/contents/$_path" \
         -f message="chore: add issue form ($_name)" -f content="$_content" >/dev/null 2>&1; then
      echo "  created $_name"
    else echo "  FAILED  $_name" >&2; fi
  fi
}

for repo in $REPOS; do
  echo "== $OWNER/$repo =="
  for f in "$SRC_DIR"/*.yml; do
    [ -e "$f" ] || continue
    put "$repo" "$f"
  done
done

echo "Done. Re-run any time; upserts are idempotent."
