#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154


# audit_password_lock
#
# Refer to Section(s) 5.4.1.5 Page(s) 689-91 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_password_lock () {
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Inactive password Lock" "check"
    if [ "${audit_mode}" != 2 ]; then
      check_file="/etc/shadow"
      inactive_time="45"
      inactive_test=$( useradd -D | grep INACTIVE | cut -f2 -d= )
      if [ "${inactive_test}" -lt "${inactive_time}" ]; then
        increment_insecure "Inactive password lock is less than ${inactive_time}"
      else
        increment_secure "Inactive password lock is equal to or greater than ${inactive_time}"
      fi
      user_list=$( awk -F: '($2~/^\$.+\$/) {if($7 > $inactive || $7 < 0)print $1 }' "${check_file}" )
      if [ "${user_list}" = "" ]; then
        increment_secure "No users with inactive password locks less that ${inactive_time}"
      else
        for user_name in ${user_list}; do
          increment_insecure "User ${user_name} has an inactive password lock less than ${inactive_time}"
        done
      fi
    else
      for check_file in /etc/passwd /etc/shadow; do
        restore_file "${check_file}" "${restore_dir}"
      done
    fi
  fi
}
