#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# funct_audit_select
#
# Selective Audit
#.

funct_audit_select () {
  print_function "funct_audit_select"
  audit_mode=$1
  module_name=$2
  module_test=$( echo "${module_name}" | grep -c aws )
  if [ "$module_test" = "1" ]; then
    check_aws
  fi
  suffix_test=$( echo "${module_name}" | grep -c "\\.sh" )
  if [ "${suffix_test}" = "1" ]; then
    module_name=$( echo "${module_name}" | cut -f1 -d. )
  fi
  module_test=$( echo "${module_name}" | grep -c "full" )
  if [ "$module_test" = "0" ]; then  
    function_test=$( echo "${module_name}" | grep -c "audit_" )
    if [ "${function_test}" = "0" ]; then
      module_name="audit_${module_name}"
    fi
  fi
  module_test=$( echo "${module_name}" | grep "audit" )
  if [ -n "$module_test" ]; then
    file_name=$( find "${modules_dir}" -name "${module_name}.sh" )
    if [ -f "${file_name}" ]; then
      print_audit_info "${module_name}"
      eval "${module_name}"
    else
      verbose_message "Audit function \"${module_name}\" does not exist" "warn"
      verbose_message "" ""
      exit
    fi 
    print_results
  else
    verbose_message "Audit function \"${module_name}\" does not exist" "warn"
    verbose_message "" ""
  fi
}
