#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../functions/aix/check_itab.sh"

os_name=AIX
audit_mode=1
ansible_mode=1
actual_value=""
actual_status=""
print_function() { :; }
check_message() { :; }
inc_insecure() { :; }
inc_secure() { :; }
fix_message() { :; }
lsitab() { return 1; }

output=$(check_itab rcnfs off)
printf '%s\n' "${output}" | grep -Fqx '    name: rcnfs'
printf '%s\n' "${output}" | grep -Fqx '    state: absent'
if printf '%s\n' "${output}" | grep -Eq 'namw:|state: off'; then
  echo "invalid AIX Ansible arguments were emitted" >&2
  exit 1
fi

echo "check_itab Ansible output passed"
