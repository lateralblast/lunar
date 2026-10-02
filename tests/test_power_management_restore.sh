#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/power/audit_power_management.sh"
tmp_dir=$(mktemp -d)
trap 'rm -rf "${tmp_dir}"' EXIT HUP INT TERM
restore_dir="${tmp_dir}/restore"
mkdir "${restore_dir}"
printf '%s\n' true > "${restore_dir}/poweradm.log"

os_name=SunOS
os_version=11
audit_mode=2
calls=""
print_function() { :; }
check_message() { :; }
command_message() { :; }
restore_message() { :; }
eval() {
  case "$1" in
    *'poweradm list'*) printf '%s\n' false ;;
    *'poweradm set'*) calls="${calls}${1};" ;;
    *'poweradm update'*) calls="${calls}${1};" ;;
    *) return 1 ;;
  esac
}

audit_power_management

case "${calls}" in
  *'poweradm set suspend-enable=true;'*'poweradm update;'*) ;;
  *)
    echo "Saved Solaris suspend state was not restored: ${calls}" >&2
    exit 1
    ;;
esac

echo "Solaris power suspend restore path passed"
