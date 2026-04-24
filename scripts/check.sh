#!/usr/bin/env bash
# Dry-run: report per-file status and exit 1 if anything would change.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./manifest.sh
source "$SCRIPT_DIR/manifest.sh"

drift=0

for entry in "${SYMLINKS[@]}"; do
  src="${entry%%:*}"
  tgt="${entry#*:}"

  if [ ! -e "$tgt" ] && [ ! -L "$tgt" ]; then
    printf '+ create   %s → %s\n' "$tgt" "$src"
    drift=1
    continue
  fi

  if [ -L "$tgt" ]; then
    cur="$(readlink "$tgt")"
    if [ "$cur" = "$src" ]; then
      printf '= ok       %s → %s\n' "$tgt" "$src"
    else
      printf '~ retarget %s (was → %s, will → %s)\n' "$tgt" "$cur" "$src"
      drift=1
    fi
    continue
  fi

  if [ -d "$tgt" ]; then
    printf '! error    %s is a directory; manual resolution required\n' "$tgt"
    drift=1
    continue
  fi

  if [ -f "$tgt" ]; then
    if cmp -s "$tgt" "$src"; then
      printf '= match    %s (content matches, would swap to symlink)\n' "$tgt"
    else
      printf '~ differ   %s\n' "$tgt"
      diff -u "$tgt" "$src" || true
      drift=1
    fi
    continue
  fi

  printf '? unknown  %s (not a file, dir, or symlink)\n' "$tgt"
  drift=1
done

exit "$drift"
