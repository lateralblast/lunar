#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/login/audit_retry_limit.sh"

os_name=SunOS
os_version=11
audit_mode=1
restart_calls=0
print_function() { :; }
check_message() { :; }
check_file_value() { :; }
svcadm() { restart_calls=$((restart_calls + 1)); }

audit_retry_limit

[ "${restart_calls}" = 0 ] || {
  echo "Audit mode restarted the name-service cache" >&2
  exit 1
}

echo "retry-limit audit has no service restart side effect"
