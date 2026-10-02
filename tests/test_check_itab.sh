#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../functions/aix/check_itab.sh"

os_name=AIX
audit_mode=1
ansible_mode=0
actual_value=""
insecure_count=0
secure_count=0

print_function() { :; }
check_message() { :; }
inc_insecure() { insecure_count=$((insecure_count + 1)); }
inc_secure() { secure_count=$((secure_count + 1)); }
fix_message() { :; }
lsitab() {
  if [ -n "${LSITAB_RECORD:-}" ]; then
    printf '%s\n' "${LSITAB_RECORD}"
  else
    return 1
  fi
}

LSITAB_RECORD='rcnfs:2:respawn:/etc/rc.nfs' check_itab rcnfs off
[ "${insecure_count}" -eq 1 ] || { echo "present entry was not reported insecure" >&2; exit 1; }

LSITAB_RECORD="" check_itab rcnfs off
[ "${secure_count}" -eq 1 ] || { echo "absent entry was not reported secure" >&2; exit 1; }

echo "check_itab presence cases passed"
