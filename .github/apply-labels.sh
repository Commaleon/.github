#!/usr/bin/env sh
#
# apply-labels.sh â€” upsert the Commaleon label taxonomy into a repo.
#
# Usage:
#   ./apply-labels.sh OWNER/REPO [path/to/labels.json]
#
# Examples:
#   ./apply-labels.sh Commaleon/crm
#   ./apply-labels.sh Commaleon/pim .github/labels.json
#
# Requirements:
#   - gh (GitHub CLI), authenticated: `gh auth login`
#   - No jq required; parsing is done via `gh --jq` for remote reads and a
#     minimal POSIX sed reader for the local labels.json.
#
# Behaviour:
#   Idempotent upsert. For each label it PATCHes the existing label (matched
#   by name), or POSTs a new one if it does not exist yet. Safe to re-run.
#
set -eu

REPO="${1:-}"
LABELS_FILE="${2:-}"

if [ -z "$REPO" ]; then
  echo "usage: $0 OWNER/REPO [path/to/labels.json]" >&2
  exit 2
fi

# Default the labels file to the copy next to this script.
if [ -z "$LABELS_FILE" ]; then
  SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
  LABELS_FILE="$SCRIPT_DIR/labels.json"
fi

if [ ! -f "$LABELS_FILE" ]; then
  echo "error: labels file not found: $LABELS_FILE" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh (GitHub CLI) is not installed or not on PATH" >&2
  exit 1
fi

OWNER=$(printf '%s' "$REPO" | cut -d/ -f1)
NAME=$(printf '%s' "$REPO" | cut -d/ -f2)
if [ -z "$OWNER" ] || [ -z "$NAME" ] || [ "$OWNER" = "$NAME" ]; then
  echo "error: repo must be in OWNER/REPO form, got: $REPO" >&2
  exit 2
fi

echo "Applying labels from $LABELS_FILE to $OWNER/$NAME ..."

# Sanity check: confirm we can reach the labels endpoint (name + auth).
if ! gh api "repos/$OWNER/$NAME/labels" --jq 'length' >/dev/null 2>&1; then
  echo "error: cannot access repos/$OWNER/$NAME/labels (check name and auth)" >&2
  exit 1
fi

created=0
updated=0
failed=0

# URL-encode spaces in a label name for use in the labels/{name} path.
urlenc() {
  printf '%s' "$1" | sed 's/ /%20/g'
}

upsert() {
  _name="$1"; _color="$2"; _desc="$3"
  [ -z "$_name" ] && return 0
  _enc=$(urlenc "$_name")

  if gh api "repos/$OWNER/$NAME/labels/$_enc" >/dev/null 2>&1; then
    if gh api --method PATCH "repos/$OWNER/$NAME/labels/$_enc" \
         -f new_name="$_name" \
         -f color="$_color" \
         -f description="$_desc" >/dev/null 2>&1; then
      echo "  updated  $_name"
      updated=$((updated + 1))
    else
      echo "  FAILED   $_name (update)" >&2
      failed=$((failed + 1))
    fi
  else
    if gh api --method POST "repos/$OWNER/$NAME/labels" \
         -f name="$_name" \
         -f color="$_color" \
         -f description="$_desc" >/dev/null 2>&1; then
      echo "  created  $_name"
      created=$((created + 1))
    else
      echo "  FAILED   $_name (create)" >&2
      failed=$((failed + 1))
    fi
  fi
}

# --- Minimal POSIX JSON array reader --------------------------------------
# Normalize labels.json into TSV records tagged N/C/D (name/color/description),
# one field per line. This matches the committed labels.json layout (one
# field per line). No external jq binary required.
TSV=$(
  tr -d '\r' < "$LABELS_FILE" \
  | sed -n \
      -e 's/^[[:space:]]*"name"[[:space:]]*:[[:space:]]*"\(.*\)",[[:space:]]*$/N\t\1/p' \
      -e 's/^[[:space:]]*"color"[[:space:]]*:[[:space:]]*"\(.*\)",[[:space:]]*$/C\t\1/p' \
      -e 's/^[[:space:]]*"description"[[:space:]]*:[[:space:]]*"\(.*\)"[[:space:]]*$/D\t\1/p'
)

TAB=$(printf '\t')
cur_name=""; cur_color=""; cur_desc=""

# Iterate in the main shell (not a pipeline subshell) so the counters set by
# upsert survive to the final summary.
OLD_IFS=$IFS
printf '%s\n' "$TSV" | while IFS="$TAB" read -r tag val; do
  case "$tag" in
    N)
      if [ -n "$cur_name" ]; then
        upsert "$cur_name" "$cur_color" "$cur_desc"
      fi
      cur_name="$val"; cur_color=""; cur_desc=""
      ;;
    C) cur_color="$val" ;;
    D)
      cur_desc="$val"
      upsert "$cur_name" "$cur_color" "$cur_desc"
      cur_name=""; cur_color=""; cur_desc=""
      ;;
  esac
done
IFS=$OLD_IFS

echo "Done. Re-run any time; upserts are idempotent."
