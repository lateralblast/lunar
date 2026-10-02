#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/mounts/audit_mount_fdi.sh"
test_dir=$(mktemp -d)
trap 'rm -rf "${test_dir}"' EXIT HUP INT TERM
policy_file="${test_dir}/floppycdrom.fdi"

[ "$(check_mount_fdi_enabled "${policy_file}")" = 1 ] || {
  echo "missing FDI policy was not reported insecure" >&2
  exit 1
}

: > "${policy_file}"
[ "$(check_mount_fdi_enabled "${policy_file}")" = 1 ] || {
  echo "empty FDI policy was not reported insecure" >&2
  exit 1
}

printf '%s\n' '<!-- Default policies merged onto computer root object -->' > "${policy_file}"
[ "$(check_mount_fdi_enabled "${policy_file}")" = 0 ] || {
  echo "default-only FDI policy was misclassified" >&2
  exit 1
}

echo "mount FDI missing/default detection passed"
