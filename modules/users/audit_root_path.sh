#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_root_path
#
# Check root path
#
# Refer to Section(s) 9.2.6         Page(s) 165-166       CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.6         Page(s) 191-2         CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.6         Page(s) 167           CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.6         Page(s) 279-80        CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.6          Page(s) 157-8         CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.12.20       Page(s) 223           CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.6           Page(s) 76-7          CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.6           Page(s) 120-1         CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.6         Page(s) 257-8         CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.6         Page(s) 271-2         CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 5.4.2.5,6.2.6 Page(s) 702-4,271-2   CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_root_path () {
  print_function "audit_root_path"
  string="Root PATH Environment Integrity"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "AIX" ]; then
    if [ "${audit_mode}" != 2 ]; then
      if [ "${audit_mode}" = 1 ]; then
        command="echo \"$PATH\" | grep \"::\""
        command_message "${command}"
        path_check=$( eval "${command}" )
        if [ "${path_check}" != "" ]; then
          increment_insecure  "Empty directory in PATH"
        else
          increment_secure    "No empty directory in PATH"
        fi
        command="echo \"$PATH\" | grep \":$\""
        command_message "${command}"
        path_check=$( eval "${command}" )
        if [ "${path_check}"  != "" ]; then
          increment_insecure  "Trailing : in PATH"
        else
          increment_secure    "No trailing : in PATH"
        fi
        command="echo \"$PATH\" | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'"
        command_message "${command}"
        dir_list=$( eval "${command}" )
        for dir_name in ${dir_list}$; do
          if [ "${dir_name}" = "." ]; then
            increment_insecure "PATH contains ."
          fi
          if [ -d "${dir_name}" ]; then
            command="find \"${dir_name}\" -maxdepth 1 -type f -writable \( -perm -g+w \)"
            command_message "${command}"
            groupackage_test=$( eval "${command}" )
            if [ -n "${groupackage_test}" ]; then
              increment_insecure "Group write permissions set on directory \"${dir_name}\""
            else
              increment_secure   "Group write permission not set on directory \"${dir_name}\""
            fi
            command="find \"${dir_name}\" -maxdepth 1 -type f -writable \( -perm -o+w \)"
            command_message "${command}"
            other_test=$( eval "${command}" )  
            if [ -n "${other_test}" ]; then
              increment_insecure "Other write permissions set on directory \"${dir_name}\""
            else
              increment_secure   "Other write permission not set on directory \"${dir_name}\""
            fi
          fi
        done
      fi
    fi
  else
    na_message "${string}"
  fi
}
