# funct_audit_select
#
# Selective Audit
#.

funct_audit_select () {
  audit_mode=$1
  function=$2
  check_environment
  if [ "`expr $function : audit_`" != "6" ]; then
    function="audit_$function"
  fi
  funct_print_audit_info $function
  $function
  print_results
}
