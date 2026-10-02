#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "${script_dir}/../functions/linux/check_systemctl_service.sh"

os_name=Linux
os_vendor=Ubuntu
os_version=22
ansible_mode=1
audit_mode=1
print_function() { :; }
check_message() { :; }
inc_insecure() { :; }
inc_secure() { :; }
update_log() { :; }
run_lockdown() { :; }
systemctl() {
  if [ "${1}" = "is-enabled" ]; then
    echo disabled
  fi
}

enabled=no
output=$(check_systemctl_service enabled example)
printf '%s\n' "${output}" | grep -Fqx '    enabled: yes'

enabled=yes
output=$(check_systemctl_service disabled example)
printf '%s\n' "${output}" | grep -Fqx '    enabled: no'

echo "check_systemctl_service Ansible output passed"
