#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# funct_audit_select
#
# Selective Audit
#.

funct_audit_select () {
  audit_mode=$1
  function=$2
  check_environment
  module_test=$( echo "${function}" |grep -c aws )
  if [ "$module_test" = "1" ]; then
    check_aws
  fi
  suffix_test=$( echo "${function}" |grep -c "\\.sh" )
  if [ "${suffix_test}" = "1" ]; then
    function=$( echo "${function}" |cut -f1 -d. )
  fi
  module_test=$( echo "${function}" | grep -c "full" )
  if [ "$module_test" = "0" ]; then  
    function_test=$( echo "${function}" | grep -c "audit_" )
    if [ "${function_test}" = "0" ]; then
      function="audit_${function}"
    fi
  fi
  module_test=$( echo "${function}" | grep "audit" )
  if [ -n "$module_test" ]; then
    if [ -f "${modules_dir}/${function}.sh" ]; then
      print_audit_info "${function}"
      eval "${function}"
    else
      verbose_message "Audit function \"${function}\" does not exist" "warn"
      verbose_message "" ""
      exit
    fi 
    print_results
  else
    verbose_message "Audit function \"${function}\" does not exist" "warn"
    verbose_message "" ""
  fi
}
