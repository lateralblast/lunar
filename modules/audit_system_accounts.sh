#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_system_accounts
#
# Check system accounts
#
# Refer to Section(s) 7.2     Page(s) 146-147 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.2     Page(s) 169     CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 7.2     Page(s) 149-150 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.4.2   Page(s) 252     CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 10.2    Page(s) 138-9   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.1     Page(s) 27      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 9.3     Page(s) 73-4    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.1     Page(s) 100-1   CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.4.2   Page(s) 231     CIS Amazon Linux v2.0.0
# Refer to Section(s) 5.4.2   Page(s) 244     CIS Ubuntu 16.04 v2.0.0`
# Refer to Section(s) 5.4.2.7 Page(s) 708-10  CIS Ubuntu 24.04 v1.0.0`
#.

audit_system_accounts () {
  print_function "audit_system_accounts"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    verbose_message "System Accounts that do not have a shell" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    password_file="/etc/passwd"
    shadow_file="/etc/shadow"
    if test -r "$shadow_file"; then
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<500 && $7!="/sbin/nologin" && $7!="/bin/false" ) {print $1}' < "${password_file}" )
        for user_name in ${user_list}; do
          shadow_field=$( grep "${user_name}:" "${shadow_file}" | grep -Ev "\*|\!\!|NP|UP|LK" | cut -f1 -d: );
          if [ "$shadow_field" = "${user_name}" ]; then
            increment_insecure "System account \"${user_name}\" has an invalid shell but the account is disabled"
          else
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "System account \"${user_name}\" has an invalid shell"
              if [ "${os_name}" = "FreeBSD" ]; then
                lockdown_command="pw moduser ${user_name} -s /sbin/nologin"
                verbose_message  "${lockdown_command}" "fix"
              else
                lockdown_command="usermod -s /sbin/nologin ${user_name}"
                verbose_message  "${lockdown_command}" "fix"
              fi
            fi
            if [ "${audit_mode}" = 0 ]; then
              lockdown_message="System account \"${user_name}\" to have shell /sbin/nologin"
              backup_file      "${password_file}"
              execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
            fi
          fi
        done
      else
        restore_file "${password_file}" "${restore_dir}"
      fi
    fi
  fi
}
