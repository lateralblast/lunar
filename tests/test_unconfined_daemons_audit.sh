#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/services/audit_unconfined_daemons.sh"

os_name=Linux
audit_mode=1
fixture=""
secure=""
insecure=""
print_function() { :; }
check_message() { :; }
command_message() { :; }
eval() { printf '%s' "${fixture}"; }
inc_secure() { secure="$1"; }
inc_insecure() { insecure="$1"; }

fixture="sshd"
audit_unconfined_daemons
[ -n "${insecure}" ] && [ -z "${secure}" ] || {
  echo "Unconfined process match was not reported insecure" >&2
  exit 1
}

secure=""
insecure=""
fixture=""
audit_unconfined_daemons
[ -n "${secure}" ] && [ -z "${insecure}" ] || {
  echo "Empty unconfined process result was not reported secure" >&2
  exit 1
}

echo "unconfined daemon findings passed"
