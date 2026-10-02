#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/logs/audit_logadm_value.sh"

os_name=SunOS
os_version=10
audit_mode=1
secure=""
insecure=""
print_function() { :; }
check_message() { :; }
command_message() { :; }
eval() { printf '%s\n' '/var/log/messages -C 13'; }
inc_secure() { secure="$1"; }
inc_insecure() { insecure="$1"; }

audit_logadm_value messages auth.notice

[ -n "${secure}" ] && [ -z "${insecure}" ] || {
  echo "Configured logadm output was not recognized as enabled" >&2
  exit 1
}

echo "Solaris logadm enabled audit passed"
