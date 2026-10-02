#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/linux/audit_xinetd.sh"
check_dir=$(mktemp -d)
trap 'rm -rf "${check_dir}"' EXIT HUP INT TERM

printf '%s\n' 'disable = no' > "${check_dir}/enabled"
printf '%s\n' 'disable = yes' > "${check_dir}/disabled"
[ "$(check_xinetd_enabled "${check_dir}")" = 1 ] || {
  echo "enabled xinetd entry was not detected" >&2
  exit 1
}

rm "${check_dir}/enabled"
[ "$(check_xinetd_enabled "${check_dir}")" = 0 ] || {
  echo "disabled xinetd entries were reported enabled" >&2
  exit 1
}

echo "xinetd detection passed"
