#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154


# audit_group_fields
#
# Refer to Section(s) 5.4.2.3 Page(s) 698-9 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_group_fields () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "Group Fields" "check"
    if [ "${audit_mode}" != 2 ]; then
      check_file="/etc/group"
      group_list=$( awk -F: '($3 == 0) { print $1 }' "${check_file}" | grep -v root )
      if [ "${group_list}" = "" ]; then
        increment_secure "No non root groups have GID 0"
      else
        for group_name in ${group_list}; do
          if [ "$group_name" != "root" ]; then
            increment_insecure "Non root group ${group_name} has GID 0"
          fi
        done
      fi
    else
      check_file="/etc/group"
      restore_file "${check_file}" "${restore_dir}"
    fi
  fi
}
