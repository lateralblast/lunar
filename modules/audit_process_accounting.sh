#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_process_accounting
#
# Refer to Section(s) 10.1 Page(s) 137-8 CIS Solaris 10 Benchmark v1.1.0
#.

audit_process_accounting () {
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message "Process Accounting" "check"
    check_file="/etc/rc3.d/S99acct"
    init_file="/etc/init.d/acct"
    log_file="${work_dir}/acct.log"
    if [ ! -f "${check_file}" ]; then
      if [ "${audit_mode}" = 1 ]; then
        increment_insecure  "Process accounting not enabled"
      fi
      if [ "${audit_mode}" = 0 ]; then
        verbose_message     "Process accounting to enabled" "set"
        echo "disabled" > "${log_file}"
        ln -s "${init_file}" "${check_file}"
        verbose_message     "Starting Process accounting" "notice"
        eval "${init_file} start > /dev/null 2>&1"
      fi
    else
      if [ "${audit_mode}" = 1 ]; then
        increment_secure    "Process accounting not enabled"
      fi
      if [ "${audit_mode}" = 2 ]; then
        log_file="${restore_dir}/acct.log"
        if [ -f "${log_file}" ]; then
          if [ -f "${check_file}" ]; then
            rm "${check_file}"
          fi
          verbose_message   "Process accounting to disabled" "restore"
          verbose_message   "Stoping Process accounting"     "notice"
          eval "${init_file} stop > /dev/null 2>&1"
        fi
      fi
    fi
  fi
}
