#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_icloud_drive
#
# Organizations should review third party storage solutions pertaining to existing data
# confidentiality and integrity requirements.
#
# Refer to Section(s) 2.1.1.2 Page(s) 45-8 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_icloud_drive () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "iCloud Drive" "check"
      if [ "$audit_mode" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in $user_list; do
          for dir_name in Documents Desktop; do
            check_value=$( sudo -u "$user_name" ls -l /Users/$user_name/Library/Mobile\ Documents/com~apple~CloudDocs/$dir_name/ | grep total | wc -l | sed "s/ //g" )
            if [ "$check_value" = "0" ]; then
              increment_secure   "Documents in \"$dir_name\" for \"$user_name\" are not syncing "
            else
              increment_insecure "Documents in \"$dir_name\" for \"$user_name\" are syncing "
            fi
          done
        done
      fi
    fi
  fi
}
