#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_user_access_admin_role
#
# Check Azure User Access Administrator Role
#
# 5.3.3 Ensure that User Access Administrator Role is restricted
# Refer to Section(s) 5.3.3 Page(s) 115-6 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_user_access_admin_role () {
  print_function "audit_azure_user_access_admin_role"
  verbose_message "Azure User Access Administrator Role" "check"
  command="az role assignment list --role \"User Access Administrator\" --scope \"/\" --output tsv"
  command_message "${command}" "exec"
  role_assignments=$( eval "${command}" )
  if [ -z "${role_assignments}" ]; then
    increment_secure   "User Access Administrator Role is restricted"
  else
    increment_insecure "User Access Administrator Role is not restricted"
    verbose_message    "az role assignment delete --role \"User Access Administrator\" --scope \"/\"" "fix"
  fi
}
