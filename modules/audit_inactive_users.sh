#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_inactive_users
#
# Check inactive users
#
# Refer to Section(s) 7.5  Page(s) 171-2   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 7.5  Page(s) 151-2   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 10.5 Page(s) 141     CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.6  Page(s) 66-7    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.9  Page(s) 109-110 CIS Solaris 10 Benchmark v5.1.0
#.

audit_inactive_users () {
  print_module "audit_inactive_users"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "Inactive User Accounts" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    if [ "${os_name}" = "SunOS" ]; then
      check_file_value "is" "/usr/sadm/defadduser" "definact" "eq" "35" "hash"
    fi
    check_file="/etc/shadow"
    if test -r "${check_file}"; then
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( grep -v "nobody4" < "${check_file}" | grep -v "root" )
        for user_check in ${user_list}; do
          inactive_check=$( echo "${user_check}" | cut -f 7 -d: )
          user_name=$( echo "${user_check}" | cut -f 1 -d: )
          if [ "$inactive_check" = "" ]; then
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure  "Inactive lockout not set for \"${user_name}\""
              verbose_message     "usermod -f 35 ${user_name}" "fix"
            fi
            if [ "${audit_mode}" = 0 ]; then
              verbose_message "File \"${check_file}\" to \"${work_dir}${check_file}\"" "save"
              find "${check_file}" | cpio -pdm "${work_dir}" 2> /dev/null
              verbose_message     "Inactive lockout for \"${user_name}\"" "set"
              usermod -f 35 "${user_name}"
            fi
          else
            if [ "${audit_mode}" = 1 ]; then
              increment_secure    "Inactive lockout set for user \"${user_name}\""
            fi
          fi
        done
      else
        restore_file "${check_file}" "${restore_dir}"
      fi
    fi
  fi
}
