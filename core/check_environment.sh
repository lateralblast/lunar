#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_environment
#
# Do some environment checks
# Create base and temporary directory
#.

check_environment () {
  check_os_release
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message "" ""
    verbose_message "Checking if node is managed" "info"
    managed_node=$( sudo pwpolicy -n -getglobalpolicy 2>&1 |cut -f1 -d: )
    if [ "${managed_node}" = "Error" ]; then
      verbose_message "Node is not managed" "notice"
    else
      verbose_message "Node is managed" "notice"
    fi
    verbose_message "" ""
  fi
  # Load functions from functions directory
  if [ -d "${functions_dir}" ]; then
    if [ "${verbose_mode}" = "1" ]; then
      echo ""
      echo "Loading Functions"
      echo ""
    fi
    file_list=$( ls "${functions_dir}"/*.sh )
    for file_name in ${file_list}; do
      if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ] ||  [ "${os_vendor}" = "Debian" ] || [ "${os_vendor}" = "Ubuntu" ]; then
        . "${file_name}"
      else
        source "${file_name}"
      fi
      if [ "${verbose_mode}" = "1" ]; then
        verbose_message "\"${file_name}\"" "load"
      fi
    done
  fi
  # Load modules for modules directory
  if [ -d "${modules_dir}" ]; then
    if [ "${verbose_mode}" = "1" ]; then
      echo ""
      echo "Loading Modules"
      echo ""
    fi
    file_list=$( ls "${modules_dir}"/*.sh )
    for file_name in ${file_list}; do
      if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ] || [ "${os_vendor}" = "Debian" ] || [ "${os_vendor}" = "Ubuntu" ]; then
        . "${file_name}"
      else
        if [ "${file_name}" = "modules/audit_ftp_users.sh" ]; then
          if [ "${os_name}" != "VMkernel" ]; then
             source "${file_name}"
          fi
        else
          source "${file_name}"
        fi
      fi
      if [ "${verbose_mode}" = "1" ]; then
        verbose_message "\"${file_name}\"" "load"
      fi
    done
  fi
  # Private modules for customers
  if [ -d "${private_dir}" ]; then
      echo ""
      echo "Loading Customised Modules"
      echo ""
    if [ "${verbose_mode}" = "1" ]; then
      echo ""
    fi
    file_list=$( ls "${private_dir}"/*.sh )
    for file_name in ${file_list}; do
      if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ] ||  [ "${os_vendor}" = "Debian" ] || [ "${os_vendor}" = "Ubuntu" ]; then
        . "${file_name}"
      else
        source "${file_name}"
      fi
    done
    if [ "${verbose_mode}" = "1" ]; then
      echo "Loading:   ${file_name}"
    fi
  fi
  if [ ! -d "${base_dir}" ]; then
    mkdir -p "${base_dir}"
    chmod 700 "${base_dir}"
  fi
  if [ ! -d "${temp_dir}" ]; then
    mkdir -p "${temp_dir}"
  fi
  if [ "${audit_mode}" = 0 ]; then
    if [ ! -d "${work_dir}" ]; then
      mkdir -p "${work_dir}"
    fi
  fi
}
