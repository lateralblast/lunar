#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../modules/sunos/audit_cde_screen_lock.sh"
test_dir=$(mktemp -d)
trap 'rm -rf "${test_dir}"' EXIT HUP INT TERM
config_dir="${test_dir}/usr/dt/config"
mkdir -p "${config_dir}/SAMPLE"
printf '%s\n' "${config_dir}/SAMPLE/sys.resources" > "${test_dir}/expected"
: > "${config_dir}/SAMPLE/sys.resources"
get_cde_resource_files "${config_dir}" > "${test_dir}/actual"
cmp -s "${test_dir}/expected" "${test_dir}/actual" || {
  echo "CDE resource discovery did not return the expected file" >&2
  exit 1
}

audit_mode=1
ensure_cde_resource_directory "${test_dir}/etc/dt/config/SAMPLE"
[ ! -d "${test_dir}/etc/dt/config/SAMPLE" ] || {
  echo "audit mode created the CDE resource directory" >&2
  exit 1
}

audit_mode=0
ensure_cde_resource_directory "${test_dir}/etc/dt/config/SAMPLE"
[ -d "${test_dir}/etc/dt/config/SAMPLE" ] || {
  echo "lockdown mode did not create the CDE resource directory" >&2
  exit 1
}

echo "CDE screen lock helper cases passed"
