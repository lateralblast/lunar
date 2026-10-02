#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/mail/audit_postfix_daemon.sh"

os_name=Linux
os_vendor=Ubuntu
os_version=24
calls=""
print_function() { :; }
check_message() { :; }
check_file_value() { calls="${calls}${3}=${5};"; }

audit_postfix_daemon

case "${calls}" in
  *'inet_interfaces=loopback-only;'*) ;;
  *)
    echo "Ubuntu 24 Postfix audit expects the wrong interface value: ${calls}" >&2
    exit 1
    ;;
esac

echo "Ubuntu 24 Postfix loopback setting passed"
