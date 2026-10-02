#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/audit/audit_auditd.sh"
test_dir=$(mktemp -d)
trap 'rm -rf "${test_dir}"' EXIT HUP INT TERM
grub_file="${test_dir}/grub"

printf '%s\n' 'GRUB_CMDLINE_LINUX="audit=0 quiet"' > "${grub_file}"
grub_has_parameter "${grub_file}" 'audit=0' || {
  echo "audit=0 was not detected" >&2
  exit 1
}
if grub_has_parameter "${grub_file}" 'audit=1'; then
  echo "audit=1 was falsely detected" >&2
  exit 1
fi

printf '%s\n' 'GRUB_CMDLINE_LINUX="audit=8192 quiet"' > "${grub_file}"
grub_has_parameter "${grub_file}" 'audit=8192' || {
  echo "audit=8192 was not detected" >&2
  exit 1
}
if grub_has_parameter "${test_dir}/missing" 'audit=0'; then
  echo "a missing GRUB file was reported as matching" >&2
  exit 1
fi

echo "auditd GRUB flag detection passed"
