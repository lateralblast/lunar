#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_root_path
#
# Check root path
#
# Refer to Section(s) 9.2.6   Page(s) 165-166 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.6   Page(s) 191-2   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.6   Page(s) 167     CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.6   Page(s) 279-80  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.6    Page(s) 157-8   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.12.20 Page(s) 223     CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.6     Page(s) 76-7    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.6     Page(s) 120-1   CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.6   Page(s) 257-8   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.6   Page(s) 271-2   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_root_path () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Root PATH Environment Integrity" "check"
    if [ "$audit_mode" != 2 ]; then
      if [ "$audit_mode" = 1 ]; then
        if [ "$( echo $PATH | grep :: )" != "" ]; then
          increment_insecure "Empty directory in PATH"
        else
          increment_secure "No empty directory in PATH"
        fi
        if [ "$( echo $PATH | grep :$ )"  != "" ]; then
          increment_insecure "Trailing : in PATH"
        else
          increment_secure "No trailing : in PATH"
        fi
        dir_list=$( echo "$PATH" | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g' )
        for dir_name in $dir_list$; do
          if [ "$dir_name" = "." ]; then
            increment_insecure "PATH contains ."
          fi
          if [ -d "$dir_name" ]; then
            group_test=$(find $dir_name -maxdepth 1 -type f -writable \( -perm -g+w \)) 
            if [ -n "$group_test" ]; then
              increment_insecure "Group write permissions set on directory \"$dir_name\""
            else
              increment_secure   "Group write permission not set on directory \"$dir_name\""
            fi
            other_test=$(find $dir_name -maxdepth 1 -type f -writable \( -perm -o+w \)) 
            if [ -n "$other_test" ]; then
              increment_insecure "Other write permissions set on directory \"$dir_name\""
            else
              increment_secure   "Other write permission not set on directory \"$dir_name\""
            fi
          fi
        done
      fi
    fi
  fi
}
