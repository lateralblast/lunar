#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/dns/audit_dns_server.sh"

os_name=AIX
named_disable=yes
calls=""
print_function() { :; }
check_message() { :; }
verbose_message() { :; }
na_message() { :; }
check_rctcp() { calls="${calls}${1}:${2}"; }

audit_dns_server
[ "${calls}" = "named:off" ] || {
  echo "AIX named check was not reached" >&2
  exit 1
}

echo "AIX DNS server control flow passed"
