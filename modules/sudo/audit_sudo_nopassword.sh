#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sudo_nopassword
#
# Check sudo NOPASSWD
#
# Refer to Section(s) 5.2.4 Page(s) 588-9 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_sudo_nopassword () {
  print_function "audit_sudo_nopassword"
  string="Sudo NOPASSWD"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ]; then
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    check_file="/etc/sudoers"
    if [ -f "${check_file}" ]; then
      command="grep \"^[^#].*NOPASSWD\" < \"${check_file}\""
      command_message "${command}"
      auth_test=$( eval "${command}" )
      if [ -n "${auth_test}" ]; then
        increment_insecure "NOPASSWD entry for sudo in ${check_file}"
      else
        increment_secure   "No NOPASSWD entry for sudo in ${check_file}"
      fi
      check_file_perms "${check_file}" "440" "root" "${wheel_group}" 
    fi
    if [ -d "/etc/sudoers.d" ]; then
      command="find /etc/sudoers.d -type file"
      command_message "${command}"
      file_list=$( eval "${command}" )
      for check_file in ${file_list}; do
        command="grep \"^[^#].*NOPASSWD\" < \"${check_file}\""
        command_message "${command}"
        auth_test=$( eval "${command}" )
        if [ -n "${auth_test}" ]; then
          increment_insecure "NOPASSWD entry for sudo in ${check_file}"
        else
          increment_secure   "No NOPASSWD entry for sudo in ${check_file}"
        fi
        check_file_perms "${check_file}" "440" "root" "${wheel_group}" 
      done
    fi
  else
    na_message "${string}"
  fi
}
