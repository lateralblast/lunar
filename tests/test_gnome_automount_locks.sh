#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/gui/audit_gnome_automount.sh"
test_dir=$(mktemp -d)
trap 'rm -rf "${test_dir}"' EXIT HUP INT TERM
lock_file="${test_dir}/00-media-automount"

write_gnome_automount_locks "${lock_file}"
expected="${test_dir}/expected"
printf '%s\n' \
  "/org/gnome/desktop/media-handling/automount" \
  "/org/gnome/desktop/media-handling/automount-open" \
  "/org/gnome/desktop/media-handling/autorun-never" > "${expected}"
cmp -s "${expected}" "${lock_file}" || {
  echo "GNOME automount lock file does not contain all settings" >&2
  exit 1
}

echo "GNOME automount locks passed"
