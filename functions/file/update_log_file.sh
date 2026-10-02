#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# update_log
#
# Update log file
#
# log_file      = Log file path or name
# log_value     = Value to append to the log file
#.

update_log () {
  log_file="${1}"
  log_value="${2}"
  print_function "update_log"
  log_dir=$( dirname "${log_file}" )
  if [ "${log_dir}" = "." ]; then
    log_file="${restore_dir}/${log_file}"
  fi
  if [ "${audit_mode}" = "0" ]; then
    echo "${log_value}" >> "${log_file}"
  fi
}
