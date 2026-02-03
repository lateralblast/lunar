#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_auditd
#
# Check auditd is installed - Required for various other tests like docker
#
# Refer to Section(s) 4.1         Page(s) 157-8       CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 4.1.1.1-4   Page(s) 278-83      CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 4.1.4.3,8   Page(s) 535-6,47-8  CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 6.2.4.1-10, Page(s) 799-806     CIS Ubuntu 24.04 Benchmark v1.0.0
#                     6.2.1.1-4           899-922     
# Refer to Section(s) 3.2         Page(s) 91          CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 3.1         Page(s) 272-3       CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_auditd () {
  print_function "audit_auditd"
  string="Audit Daemon"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    if [ "${os_name}" = "Linux" ]; then
      check_linux_package "install" "auditd"
      check_linux_package "install" "audispd-plugins" 
      check_file="/etc/default/grub"
      app_name="Audit"
      package_name="audit"
      if [ "${audit_mode}" = 2 ]; then
        restore_file "${check_file}" "${restore_dir}"
      else
        if [ -f "${check_file}" ]; then
          package_disable_test=$( grep "${package_name}=0" "${check_file}" )
          package_enabled_test=$( grep "${package_name}=1" "${check_file}" )
        else
          package_disabled_test=0
          package_enabled_test=0
        fi
        if [ -n "${package_disabled_test}" ]; then
          temp_file="${temp_dir}/${package_name}"
          increment_insecure "Application \"${app_name}\" is disabled in \"${check_file}\""
          backup_file        "${check_file}"
          execute_lockdown   "cat ${check_file} |sed 's/${package_name}=0//g' > ${temp_file} ; cat ${temp_file} > ${check_file} ; update-grub" "Application \"${app_name}\" in \"${check_file}\" to disabled"
        else
          increment_secure   "Application \"${app_name}\" is not disabled in \"${check_file}\""
        fi
        if [ -n "${package_enabled_test}" ]; then
          increment_secure "Application \"${app_name}\" is enabled \"${check_file}\""
        else
          temp_file="${temp_dir}/${package_name}"
          increment_insecure "Application \"${app_name}\" is not enabled in \"${check_file}\""
          backup_file        "${check_file}"
          line_check=$( grep "^GRUB_CMDLINE_LINUX" "${check_file}" )
          if [ -n "${line_check}" ]; then
            existing_value=$( grep "^GRUB_CMDLINE_LINUX" "${check_file}" | cut -f2 -d= |sed "s/\"//g" )
            new_value="GRUB_CMDLINE_LINUX=\"audit=1 ${existing_value}\""
            execute_lockdown "cat ${check_file} |sed 's/^GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"${new_value}\"/g' > ${temp_file} ; cat ${temp_file} > ${check_file} ; update-grub" "Application \"${app_name}\" to enabled"
          else
            execute_lockdown "echo 'GRUB_CMDLINE_LINUX=\"audit=1\"' >> ${check_file} ; update-grub" "Application \"${app_name}\" to enabled"
          fi
        fi
      fi
      package_name="audit_backlog_limit"
      package_value="8192"
      if [ "${audit_mode}" = 2 ]; then
        restore_file "${check_file}" "${restore_dir}"
      else
        if [ -f "${check_file}" ]; then
          package_disable_test=$( grep "${package_name}=0" "${check_file}" )
          package_enabled_test=$( grep  "${package_name}=${package_value}" "${check_file}" )
        else
          package_disabled_test=0
          package_enabled_test=0
        fi
        if [ -n "${package_disabled_test}" ]; then
          temp_file="${temp_dir}/${package_name}"
          increment_insecure "${app_name} is disabled in ${check_file}"
          backup_file      "${check_file}"
          lockdown_command="cat ${check_file} |sed 's/${package_name}=0//g' > ${temp_file} ; cat ${temp_file} > ${check_file} ; update-grub"
          lockdown_message="Application/Feature \"${app_name} \" in \"${check_file}\" to enabled"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          existing_value=$( grep "^GRUB_CMDLINE_LINUX" "${check_file}" |cut -f2 -d= | sed "s/\"//g" )
          new_value="GRUB_CMDLINE_LINUX=\"${package_name}=${package_value} ${existing_value}\""
          lockdown_command="cat ${check_file} |sed 's/^GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"${new_value}\"/g' > ${temp_file} ; cat ${temp_file} > ${check_file} ; update-grub"
          lockdown_message="Application/Feature \"${app_name}\" to enabled"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        else
          increment_secure "${app_name} is not disabled in ${check_file}"
        fi
        if [ -n "${package_enabled_test}" ]; then
          increment_secure   "${app_name} is enabled ${check_file}"
        else
          increment_insecure "${app_name} is not enabled in ${check_file}"
          temp_file="${temp_dir}/${package_name}"
          backup_file "${check_file}"
          line_check=$( grep "^GRUB_CMDLINE_LINUX" ${check_file} )
          if [ -n "${line_check}" ]; then
            existing_value=$( grep "^GRUB_CMDLINE_LINUX" "${check_file}" | cut -f2 -d= |sed "s/\"//g" )
            new_value="GRUB_CMDLINE_LINUX=\"${package_name}=${package_value} ${existing_value}\""
            lockdown_command="cat ${check_file} |sed 's/^GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"${new_value}\"/g' > ${temp_file} ; cat ${temp_file} > ${check_file} ; update-grub"
            lockdown_message="Application/Feature \"${app_name}\" to enabled"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          else
            lockdown_command="echo 'GRUB_CMDLINE_LINUX=\"${package_name}=${package_value}\"' >> ${check_file} ; update-grub"
            lockdown_message="Application/Feature \"${app_name}\" to enabled"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        fi
      fi
    fi
    if [ "${os_name}" = "Darwin" ]; then
      check_launchctl_service "com.apple.auditd" "on"
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service     "auditd" "on"
    fi
    check_file="/etc/audit/auditd.conf"
    check_file_value "is" "${check_file}" "log_group" "eq" "adm" "hash"
    for check_file in /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules; do
      if [ -f "${check_file}" ]; then
        check_file_perms "${check_file}" "0750" "root" "root"
      fi
    done
    if [ -d "/etc/audit" ]; then
      file_list=$( find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) )
      for check_file in ${file_list}; do
        check_file_perms "${check_file}" "0640" "root" "root"
      done
    fi
    check_file="/var/log/audit/audit.log"
    if [ -f "${check_file}" ]; then
      check_file_perms "${check_file}" "0640" "root" "root"
    fi
  else
    na_message "${string}"
  fi
}
