#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_kernel_accounting
#
# Check Kernel Accounting
#
# Refer to Section(s) 3.3     Page(s) 38-39           CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section(s) 3.3     Page(s) 92              CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 4.9     Page(s) 73-5            CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 3.2,4-5 Page(s) 274-5,8-9,280-3 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_kernel_accounting () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Darwin" ]; then
    check_file="/etc/system"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ]; then
        if [ -f "${check_file}" ]; then
          verbose_message "Kernel and Process Accounting" "check"
          check_acc=$( grep -v "^\*" "${check_file}" | grep "c2audit:audit_load" )
          if [ -z "$check_acc" ]; then
            check_file_value "is" "${check_file}" "c2audit" "colon" "audit_load" "star"
            if [ "${audit_mode}" = 0 ]; then
              log_file="${work_dir}/bsmconv.log"
              echo "y" >> "${log_file}"
              echo "y" | /etc/security/bsmconv
            fi
          fi
          if [ "${audit_mode}" = 2 ]; then
            restore_file="${restore_dir}/bsmconv.log"
            if [ -f "${restore_file}" ]; then
              echo "y" | /etc/security/bsmunconv
            fi
          fi
          check_file_value "is" "/etc/security/audit_control" "flags"   "colon" "lo,ad,cc" "hash"
          check_file_value "is" "/etc/security/audit_control" "naflags" "colon" "lo,ad,ex" "hash"
          check_file_value "is" "/etc/security/audit_control" "minfree" "colon"  "20"      "hash"
          check_file_value "is" "/etc/security/audit_user"    "root"    "colon" "lo,ad:no" "hash"
        fi
      fi
    else
      check_file_perms "/etc/security/audit_control"      "0750"  "root"  "${wheel_group}"
      check_file_perms "/var/audit" "0750" "root" "${wheel_group}"
      check_file_value "is" "/etc/security/audit_control" "flags" "colon" "lo,ad,fd,fm,-all" "hash"
      if [ "${os_version}" -ge 14 ]; then
        check_file_value "is" "/etc/security/audit_control" "expire-after" "colon" "60d" "hash"
      fi
    fi
  fi
}
