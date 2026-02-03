#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_gate_keeper
#
# Gatekeeper is Apple’s application that utilizes allowlisting to restrict downloaded
# applications from launching. It functions as a control to limit applications from unverified
# sources from running without authorization. In an update to Gatekeeper in macOS 13
# Ventura, Gatekeeper checks every application on every launch, not just quarantined apps.
#
# Refer to Section 2.5.1 Page(s) 26-27 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section 2.6.2 Page(s) 55    CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section 2.6.5 Page(s) 174-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_gate_keeper () {
  print_function "audit_gate_keeper"
  string="Gatekeeper"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    log_file="gatekeeper.log"
    if [ "${audit_mode}" != 2 ]; then
      actual_value=$( sudo spctl --status | awk '{print $2}' | sed 's/d$//g' )
      if [ "${actual_value}" = "disable" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure  "Gatekeeper is not enabled"
        fi
        if [ "${audit_mode}" = 0 ]; then
          verbose_message     "Gatekeeper to enabled" "set"
          echo "${actual_value}" > "${work_dir}/${log_file}"
          sudo spctl --master-enable
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure    "Gatekeeper is enabled"
        fi
      fi
    else
      restore_file="${restore_dir}/${log_file}"
      if [ -f "${restore_file}" ]; then
        restore_value=$( cat "${restore_file}" )
        if [ "${restore_value}" != "${actual_value}" ]; then
          verbose_message     "Gatekeeper to \"${restore_value}\"" "restore"
          eval "sudo spctl --master-${restore_value}"
        fi
      fi
    fi
  else
    na_message "${string}"
  fi
}
