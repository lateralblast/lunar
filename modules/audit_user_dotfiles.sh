#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_user_dotfiles
#
# Check permissions on user dot file
#
# Refer to Section(s) 9.2.8  Page(s) 167-168 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.2.10 Page(s) 284     CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 9.2.8  Page(s) 193-4   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 13.8   Page(s) 159     CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.2    Page(s) 25      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 9.8    Page(s) 77-8    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.8    Page(s) 122     CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.10 Page(s) 262     CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.10 Page(s) 276     CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 7.2.10 Page(s) 986-92      CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_user_dotfiles () {
  print_function "audit_user_dotfiles"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    verbose_message "User Dot Files" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    home_dirs=$( grep -v "^/$" < /etc/passwd | cut -f6 -d":" )
    for home_dir in ${home_dirs}; do
      file_list=$( find "${home_dir}" -name ".[A-Za-z0-9]*" -depth 1 )
      for check_file in ${file_list}; do
        if [ -f "${check_file}" ]; then
          check_file_perms "${check_file}" "0600" "" ""
        fi
      done
    done
  fi
}
