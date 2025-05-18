#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sulogin
#
# Check single user mode requires password
#
# Refer to Section(s) 1.5.4-5 Page(s) 43-44 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.3   Page(s) 60    CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 3.2     Page(s) 9     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 3.4     Page(s) 33-4  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.5.4-5 Page(s) 48-9  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.5.4-5 Page(s) 45-6  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.4.2-3 Page(s) 51-2  CIS Amazon Linux Benchmark v2.0.0
#.

audit_sulogin () {
  print_module "audit_sulogin"
  temp_file="${temp_dir}/audit_sulogin"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    verbose_message "Single User Mode Requires Password" "check"
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file="/etc/ttys"
      check_string="console"
      ttys_test=$( grep "${check_string}" ${check_file} | awk '{print $5}' )
      if [ "${ttys_test}" != "insecure" ]; then
        if [ "${audit_mode}" != 2 ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Single user mode does not require a password"
          fi
          if [ "${audit_mode}" = 2 ]; then
            verbose_message  "Setting:   Single user mode to require a password" "set"
            backup_file      "${check_file}"
            lockdown_command="awk '($4 == \"console\") { $5 = \"insecure\" } { print }' < ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        else
          restore_file "${check_file}" "${restore_dir}"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Single user login requires password"
        fi
      fi
    fi
    if [ "${os_name}" = "Linux" ] && [ "${os_vendor}" = "Red" ] && [ "${os_version}" = "7" ]; then
      check_file_value "is" "/usr/lib/systemd/system/rescue.service"    "ExecStart" "eq" "-/bin/sh -c \"/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\"" "hash" "2" "blockdefault"
      check_file_value "is" "/usr/lib/systemd/system/emergency.service" "ExecStart" "eq" "-/bin/sh -c \"/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\"" "hash" "2" "blockdefault"
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_file="/etc/inittab"
      if [ -f "${check_file}" ]; then
        sulogin_check=$( grep -l sulogin "${check_file}" )
        if [ -z "$sulogin_check" ]; then
          lockdown_message="Single user mode to require authentication"
          lockdown_command="awk '{ print }; /^id:[0123456sS]:initdefault:/ { print \"~~:S:wait:/sbin/sulogin\" }' < ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm $temp_file"
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "No Authentication required for single usermode"
            verbose_message    "${lockdown_command}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file      "${check_file}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "Single usermode requires authentication"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
          if [ "${audit_mode}" = 2 ]; then
            restore_file   "${check_file}" "${restore_dir}"
          fi
          check_file_perms "${check_file}" "0600" "root" "root"
        fi
        check_file="/etc/sysconfig/init"
        check_file_value "is" "/etc/sysconfig/init" "SINGLE" "eq"   "/sbin/sulogin" "hash"
        check_file_value "is" "/etc/sysconfig/init" "PROMPT" "eq"   "no"            "hash"
        check_file_perms "/etc/sysconfig/init"      "0600"   "root" "root"
      fi
      check_file_value   "is" "/etc/sysconfig/boot" "PROMPT_FOR_CONFIRM" "eq" "no" "hash"
    fi
  fi
}
