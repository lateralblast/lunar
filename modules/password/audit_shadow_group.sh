#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_shadow_group
#
# Check shadow group
#
# Refer to Section(s) 13.20   Page(s) 168-9 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.2.20  Page(s) 287   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.2.4   Page(s) 972-3 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_shadow_group () {
  print_function "audit_shadow_group"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Shadow Group" "check"
    check_file="/etc/group"
    temp_file="${temp_dir}/group"
    if [ "${audit_mode}" = 2 ]; then
      restore_file "${check_file}" "${restore_dir}"
    fi
    if [ "${audit_mode}" != 2 ]; then
      shadow_check=$( grep -v "^#" "${check_file}" | grep ^shadow | cut -f4 -d":" | wc -c | sed "s/ //g" )
      if [ "$shadow_check" != 0 ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "Shadow group contains members"
          verbose_message    "cat ${check_file} |awk -F':' '( \$1 == \"shadow\" ) {print \$1\":\"\$2\":\"\$3\":\" ; next}; {print}' > ${temp_file}" "fix"
          verbose_message    "cat ${temp_file} > ${check_file}" "fix"
          verbose_message    "rm ${temp_file}" "fix"
        fi
        if [ "${audit_mode}" = 0 ]; then
          backup_file "${check_file}"
          command="awk -F':' '( \$1 == \"shadow\" ) {print \$1\":\"\${2}\":\"\${3}\":\" ; next}; {print}' < \"${check_file}\" > \"${temp_file}\""
          command_message "${command}"
          eval "${command}"
          command="cat \"${temp_file}\" > \"${check_file}\""
          command_message "${command}"
          eval "${command}"
          command="rm \"${temp_file}\""
          command_message "${command}"
          eval "${command}"
        fi
      else
        if [ "${audit_mode}" = 1 ];then
          increment_secure "No members in shadow group"
        fi
      fi
    fi
  fi
}
