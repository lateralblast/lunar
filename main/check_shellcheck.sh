#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_shellcheck
# 
# Run shellcheck against script
#.

check_shellcheck () {
  print_function "check_shellcheck"
  shellcheck_bin=$( command -v shellcheck 2> /dev/null )
  if [ -z "${shellcheck_bin}" ]; then
    warn_message "ShellCheck is not installed"
    return 127
  fi
  check_status=0
  echo "Checking $0"
  "${shellcheck_bin}" "$0" || check_status=1
  for dir_name in "${main_dir}" "${functions_dir}" "${modules_dir}"; do
    if [ -d "${dir_name}" ]; then
      file_list=$( find "${dir_name}" -name "*.sh" -type f -print )
      for file_name in ${file_list}; do
        if [ "${verbose_mode}" = "1" ]; then
          verbose_message "\"${file_name}\"" "load"
        fi
        echo "Checking ${file_name}"
        "${shellcheck_bin}" "${file_name}" || check_status=1
      done
    fi
  done
  return "${check_status}"
}
