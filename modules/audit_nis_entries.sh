#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_nis_entries
#
# Check NIS entries
#
# Refer to Section(s) 9.2.2-4 Page(s) 163-5   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.2-4 Page(s) 188-190 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.2-4 Page(s) 166-8   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 13.2-4  Page(s) 154-6   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 9.4     Page(s) 118-9   CIS Solaris 10 Benchmark v1.1.0
#.

audit_nis_entries () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "NIS Map Entries" "check"
    for check_file in /etc/passwd /etc/shadow /etc/group; do
      if test -r "$check_file"; then
        if [ "$audit_mode" != 2 ]; then
          entry_check=$( grep "^\+" "$check_file" | wc -l)
          if [ ! "$entry_check" = "0" ]; then
            file_entries=$( grep "^\+" "$check_file" )
            for file_entry in $file_entries; do
              if [ "$audit_mode" = 1 ]; then
                increment_insecure "NIS entry \"$file_entry\" in $check_file"
                verbose_message    "sed -e \"s/^\+/#&/\" < $check_file > $temp_file" "fix"
                verbose_message    "cat $temp_file > $check_file" "fix"
              fi
              if [ "$audit_mode" = 0 ]; then
                backup_file $check_file
                verbose_message "File \"$check_file\" to have no NIS entries" "set"
                sed -e "s/^+/#&/" < "$check_file" > "$temp_file"
                cat "$temp_file" > "$check_file"
                if [ "$os_name" = "SunOS" ]; then
                  if [ "$os_version" != "11" ]; then
                    pkgchk -f -n -p "$check_file" 2> /dev/null
                  else
                    pkg fix $( pkg search "$check_file" | grep pkg | awk '{print $4}' )
                  fi
                fi
                if [ -f "$temp_file" ]; then
                  rm "$temp_file"
                fi
              fi
            done
            if [ "$file_entry" = "" ]; then
              if [ "$audit_mode" = 1 ]; then
                increment_secure "No NIS entries in \"$check_file\""
              fi
            fi
          fi
        else
          restore_file "$check_file" "$restore_dir"
        fi
      fi
    done
  fi
}
