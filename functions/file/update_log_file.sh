#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# update_log
#
# Update log file
#
# log_file      = The name of the original file
# log_vale      = The directory to restore from
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
