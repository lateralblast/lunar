#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_exim
#
# Check exim
#
# Refer to Section(s) 1.5.1 Page(s) 88-9 CIS Ubuntu 22.04 Benchmark v1.0.0
#.

audit_exim () {
  print_function "audit_exim"
  string="Exim"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    check_file="/etc/exim4/update-exim4.conf"
    if [ -f "${check_file}" ]; then
      check_file_value  "is" "${check_file}" "dc_eximconfig_configtype" "eq" "'local'"           "hash"
      check_file_value  "is" "${check_file}" "dc_local_interfaces"      "eq" "'127.0.0.1 ; ::1'" "hash"
      check_file_value  "is" "${check_file}" "dc_readhost"              "eq" "''"                "hash"
      check_file_value  "is" "${check_file}" "dc_relay_domains"         "eq" "''"                "hash"
      check_file_value  "is" "${check_file}" "dc_minimaldns"            "eq" "'false'"           "hash"
      check_file_value  "is" "${check_file}" "dc_relay_nets"            "eq" "''"                "hash"
      check_file_value  "is" "${check_file}" "dc_smarthost"             "eq" "''"                "hash"
      check_file_value  "is" "${check_file}" "dc_use_split_config"      "eq" "'false'"           "hash"
      check_file_value  "is" "${check_file}" "dc_hide_mailname"         "eq" "''"                "hash"
      check_file_value  "is" "${check_file}" "dc_mailname_in_oh"        "eq" "'true'"            "hash"
      check_file_value  "is" "${check_file}" "dc_localdelivery"         "eq" "'mail_spool'"      "hash"
    fi
  else
    na_message "${string}"
  fi
}