#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/accounting/audit_system_accounts.sh"

os_name=Linux
my_id=0
use_sudo=1
audit_mode=0
tmp_dir=$(mktemp -d)
trap 'rm -rf "${tmp_dir}"' EXIT HUP INT TERM
password_file="${tmp_dir}/passwd"
shadow_file="${tmp_dir}/shadow"
touch "${password_file}" "${shadow_file}"
calls=""
print_function() { :; }
check_message() { :; }
command_message() { :; }
backup_file() { :; }
run_lockdown() { calls="${1}|${2}|${3}"; }
eval() {
  case "$1" in
    *"awk -F:"*) printf '%s\n' daemon ;;
    *"grep \"daemon:"*) printf '%s\n' /path/that/does/not/exist ;;
    *) return 1 ;;
  esac
}

audit_system_accounts

[ "${calls}" = 'usermod -s /sbin/nologin daemon|System account "daemon" to have shell /sbin/nologin|sudo' ] || {
  echo "Unexpected lockdown command: ${calls}" >&2
  exit 1
}

echo "system account lockdown command passed"
