#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_sticky_bit
#
# Check sticky bits set of files
#
# Refer to Section(s) 1.17   Page(s) 26    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.21 Page(s) 46    CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.17 Page(s) 28    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.17 Page(s) 27    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.17   Page(s) 26    CIS SLES 11 Benchmark v1.2.0
# Refer to Section(s) 6.3    Page(s) 21-22 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.3    Page(s) 77-8  CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 1.1.18 Page(s) 42    CIS Amazon Linux Benchmark v2.0.0
#.

audit_sticky_bit () {
  print_module "audit_sticky_bit"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    if [ "${do_fs}" = 1 ]; then
      string="World Writable Directories and Sticky Bits"
      verbose_message "${string}" "check"
      if [ "${os_version}" = "10" ]; then
        log_file="sticky_bits"
        file_list=$( find / \( -fstype nfs -o -fstype cachefs \
          -o -fstype autofs -o -fstype ctfs \
          -o -fstype mntfs -o -fstype objfs \
          -o -fstype proc \) -prune -o -type d \
          \( -perm -0002 -a -perm -1000 \) -print )
        for check_dir in ${file_list}; do
          lockdown_command="sudo chmod +t ${check_dir}"
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Sticky bit not set on \"${check_dir}\""
            verbose_message    "${lockdown_command}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            update_log_file "${log_file}" "${check_dir}"
            verbose_message "Sticky bit on \"${check_dir}\"" "set"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
          if [ "${ansible}" = 1 ]; then
            echo ""
            echo "- name: Checking ${string} on ${check_dir}"
            echo "  command: sh -c \"sudo chmod +t ${check_dir}\""
            echo "  ignore_errors: true"
            echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
            echo ""
          else
            lockdown_message="Sticky bit from \"${check_dir}\""
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        done
        if [ "${audit_mode}" = 2 ]; then
          restore_file="${restore_dir}/sticky_bits"
          if [ -f "${restore_file}" ]; then
            check_dirs=$( cat "${restore_file}" )
            for check_dir in ${check_dirs}; do
              if [ -d "${check_dir}" ]; then
                restore_command="sudo chmod -t ${check_dir}"
                restore_message="Removing sticky bit from \"${check_dir}\""
                execute_restore "${restore_command}" "${restore_message}" "sudo"
              fi
            done
          fi
        fi
      fi
    fi
  fi
}
