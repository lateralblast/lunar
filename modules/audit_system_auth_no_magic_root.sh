#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_system_auth_no_magic_root
#
# Make sure root account isn't locked as part of account locking
#.

audit_system_auth_no_magic_root () {
  auth_string=$1
  search_string=$2
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do 
        if [ -f "$check_file" ]; then
          verbose_message "Auth entry not enabled in \"$check_file\""
          check_value=$( grep "^$auth_string" "$check_file" | grep "$search_string$" | awk '{print $5}' )
          if [ "$check_value" != "$search_string" ]; then
            if [ "$audit_mode" = "1" ]; then
              increment_insecure "Auth entry not enabled in \"$check_file\""
              if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 22 ]; then
                verbose_message "cat $temp_file |awk '( $1 == \"auth\" && $2 == \"required\" && $3 == \"pam_deny.so\" ) { print \"auth\trequired\tpam_faillock.so onerr=fail no_magic_root\"; print $0; next };' < $temp_file> $check_file" "fix"
              else
                verbose_message "cat $temp_file |awk '( $1 == \"auth\" && $2 == \"required\" && $3 == \"pam_deny.so\" ) { print \"auth\trequired\tpam_tally2.so onerr=fail no_magic_root\"; print $0; next };' < $temp_file > $check_file" "fix"
              fi
              verbose_message "rm $temp_file" "fix"
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file      "$check_file"
              verbose_message  "Setting:   Auth entry in \"$check_file\""
              cp "$check_file" "$temp_file"
              if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 22 ]; then
                awk '( $1 == "auth" && $2 == "required" && $3 == "pam_deny.so" ) { print "auth\trequired\tpam_faillock.so onerr=fail no_magic_root"; print $0; next };' < "$temp_file"  > "$check_file"
              else
                awk '( $1 == "auth" && $2 == "required" && $3 == "pam_deny.so" ) { print "auth\trequired\tpam_tally2.so onerr=fail no_magic_root"; print $0; next };'  < "$temp_file" > "$check_file"
              fi  
              if [ -f "$temp_file" ]; then
                rm "$temp_file"
              fi
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              increment_secure "Auth entry enabled in \"$check_file\""
            fi
          fi
        fi
      done
    else
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do 
        restore_file "$check_file" "$restore_dir"
      done 
    fi
  fi
}
