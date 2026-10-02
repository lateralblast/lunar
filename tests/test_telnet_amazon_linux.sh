#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/telnet/audit_telnet_server.sh"

os_name=Linux
os_vendor=Amazon
calls=""
print_function() { :; }
check_message() { :; }
na_message() { :; }
check_linux_service() { calls="${calls}service:${1}:${2};"; }
check_linux_package() { calls="${calls}package:${1}:${2};"; }

audit_telnet_server
[ "${calls}" = "service:telnet.socket:off;package:uninstall:telnet-server;" ] || {
  echo "Amazon Linux telnet checks were not reached" >&2
  exit 1
}

echo "Amazon Linux telnet control flow passed"
