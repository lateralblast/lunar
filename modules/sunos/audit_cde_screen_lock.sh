#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_cde_screen_lock
#
# Check Screen Lock for CDE Users
#
# Refer to Section(s) 6.7 Page(s) 91-2 CIS Solaris 10 Benchmark v5.1.0
#.

get_cde_resource_files () {
  config_dir="${1}"
  for cde_file in "${config_dir}"/*/sys.resources; do
    if [ -f "${cde_file}" ]; then
      printf '%s\n' "${cde_file}"
    fi
  done
}

ensure_cde_resource_directory () {
  if [ "${audit_mode}" = 0 ] && [ ! -d "${1}" ]; then
    mkdir -p "${1}"
  fi
}

audit_cde_screen_lock () {
  print_function "audit_cde_screen_lock"
  string="Screen Lock for CDE Users"
  check_message  "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    file_list=$( get_cde_resource_files "/usr/dt/config" )
    for cde_file in ${file_list}; do
      dir_name=$( dirname "$cde_file" | sed "s/usr/etc/" )
      ensure_cde_resource_directory "${dir_name}"
      check_file="${dir_name}/sys.resources"
      check_file_value "is" "${check_file}" "dtsession*saverTimeout" "colon" " 10" "star"
      check_file_value "is" "${check_file}" "dtsession*lockTimeout"  "colon" " 10" "star"
      check_file_perms      "${check_file}" "0444" "root" "sys"
    done
  else
    na_message "${string}"
  fi
}
