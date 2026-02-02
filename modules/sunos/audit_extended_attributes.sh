#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_extended_attributes
#
# Check extended attributes
#
# Refer to Section(s) 9.25 Page(s) 90-1  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.25 Page(s) 136-7 CIS Solaris 10 Benchmark v1.1.0
#.

audit_extended_attributes () {
  print_function "audit_extended_attributes"
  string="Extended Attributes"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${audit_mode}" = 1 ]; then
      file_list=$( find / \( -fstype nfs -o -fstype cachefs \
      -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
      -o -fstype objfs -o -fstype proc \) -prune \
      -o -xattr -print )
      for check_file in ${file_list}; do
        increment_insecure "File \"${check_file}\" has extended attributes"
      done
    fi
  else
    na_message "${string}"
  fi
}
