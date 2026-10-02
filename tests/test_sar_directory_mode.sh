#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/accounting/audit_sar_accounting.sh"
test_root=$(mktemp -d)
test_dir="${test_root}/var/adm/sa"
trap 'rm -rf "${test_root}"' EXIT HUP INT TERM

audit_mode=1
ensure_sar_accounting_directory "${test_dir}"
[ ! -d "${test_dir}" ] || {
  echo "audit mode created the SAR directory" >&2
  exit 1
}

audit_mode=0
ensure_sar_accounting_directory "${test_dir}"
[ -d "${test_dir}" ] || {
  echo "lockdown mode did not create the SAR directory" >&2
  exit 1
}

echo "SAR directory mode behavior passed"
