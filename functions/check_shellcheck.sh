#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_shellcheck
# 
# Run shellcheck against script
#.

check_shellcheck () {
  bin_test=$( command -v shellcheck | grep -c shellcheck )
  if [ ! "$bin_test" = "0" ]; then
    echo "Checking $0"
    shellcheck "$0"
  fi
  for dir_name in "${functions_dir}" "${modules_dir}"; do
    if [ -d "${dir_name}" ]; then
      file_list=$( ls "${dir_name}"/*.sh )
      for file_name in ${file_list}; do
        if [ "${verbose}" = "1" ]; then
          verbose_message "\"${file_name}\"" "load"
        fi
        echo "Checking ${file_name}"
        shellcheck "${file_name}"
      done
    fi
  done
}