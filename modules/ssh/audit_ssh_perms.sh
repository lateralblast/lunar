#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ssh_perms
#
# Check SSH file permission for keys etc 
#.

audit_ssh_perms () {
  print_function "audit_ssh_perms"
  string="SSH Permissions"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    for check_dir in /etc/ssh /usr/local/etc/ssh; do
      if [ -d "${check_dir}" ]; then
        command="find \"${check_dir}\" -name \"*_key\" -type f"
        command_message "${command}"
        file_list=$( eval "${command}" )
        for check_file in ${file_list}; do
          check_file_perms "${check_file}" "0600" "root" "root"
        done
        command="find \"${check_dir}\" -name \"*.pub\" -type f"
        command_message "${command}"
        file_list=$( eval "${command}" )
        for check_file in ${file_list}; do
          check_file_perms "${check_file}" "0640" "root" "root"
        done
      fi
    done
    verbose_message "User SSH Permissions" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    while IFS=":" read -r user _ uid gid _ home shell; do
      if [ -d "${home}/.ssh" ]; then
        check_file_perms "${home}/.ssh" "0700" "${uid}" "${gid}"
        command="find \"${home}/.ssh\" -type f"
        command_message "${command}"
        file_list=$( eval "${command}" )
        for check_file in ${file_list}; do
          check_file_perms "${check_file}" "0600" "${uid}" "${gid}"
        done
      fi
    done < /etc/passwd 
  else
    na_message "${string}"
  fi
}
