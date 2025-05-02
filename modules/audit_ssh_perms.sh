#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ssh_perms
#
# Check SSH file permission for keys etc 
#.

audit_ssh_perms () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    verbose_message "SSH Permissions" "check"
    for check_dir in /etc/ssh /usr/local/etc/ssh; do
      if [ -d "${check_dir}" ]; then
        file_list=$( find "${check_dir}" -name "*_key" -type f )
        for check_file in ${file_list}; do
          check_file_perms "${check_file}" "0600" "root" "root"
        done
        file_list=$( find "${check_dir}" -name "*.pub" -type f )
        for check_file in ${file_list}; do
          check_file_perms "${check_file}" "0640" "root" "root"
        done
      fi
    done
    while IFS=":" read -r user _ uid gid _ home shell; do
      if [ -d "${home}/.ssh" ]; then
        check_file_perms "${home}/.ssh" "0700" "${uid}" "${gid}"
        file_list=$( find "${home}/.ssh" -type f )
        for check_file in ${file_list}; do
          check_file_perms "${check_file}" "0600" "${uid}" "${gid}"
        done
      fi
    done < /etc/passwd 
  fi
}
