#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154 

# audit_forward_files
#
# Check dot forward files
#
# Refer to Section(s) 9.2.19 Page(s) 176-7 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.21 Page(s) 206-7 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.20 Page(s) 180-1 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.11 Page(s) 2815  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.19  Page(s) 167-8 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 9.21   Page(s) 87    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.21   Page(s) 133-4 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.11 Page(s) 263   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.11 Page(s) 277   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_forward_files () {
  print_function "audit_forward_files"
  string="User Forward Files"
  check_message "${string}" 
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    audit_dot_files ".forward"
  else
    na_message "${string}"
  fi
}
