#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_icloud_drive
#
# Organizations should review third party storage solutions pertaining to existing data
# confidentiality and integrity requirements.
#
# Refer to Section(s) 2.1.1.2 Page(s) 45-8 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_icloud_drive () {
  print_function "audit_icloud_drive"
  string="iCloud Drive"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      if [ "${audit_mode}" != 2 ]; then
        command="find /Users -maxdepth 1 |grep -vE \"localized|Shared\" |cut -f3 -d/"
        command_message "${command}"
        user_list=$( eval "${command}" )
        for user_name in ${user_list}; do
          for dir_name in Documents Desktop; do
            if [ -f "/Users/${user_name}/Library/Mobile\ Documents/com~apple~CloudDocs/${dir_name}" ]; then
              command="sudo -u \"${user_name}\" sh -c \"ls -l /Users/${user_name}/Library/Mobile\ Documents/com~apple~CloudDocs/${dir_name}/\" | grep -c total | sed \"s/ //g\""
              command_message "${command}"
              check_value=$( eval "${command}" )
              if [ "${check_value}" = "0" ]; then
                increment_secure   "Documents in \"${dir_name}\" for \"${user_name}\" are not syncing "
              else
                increment_insecure "Documents in \"${dir_name}\" for \"${user_name}\" are syncing "
              fi
            fi
          done
        done
      fi
    fi
  else
    na_message "${string}"
  fi
}
