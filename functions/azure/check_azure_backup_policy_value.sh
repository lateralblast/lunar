#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_backup_policy_value
#
# Check Azure Backup policy value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_backup_policy_value () {
  description="${1}"
  policy_name="${2}"
  vault_name="${3}"
  resource_group="${4}"
  query_string="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${8}"
  set_value="${9}"
  print_function "check_azure_backup_policy_value"
  check_message  "Azure Backup Policy ${description} for policy \"${policy_name}\" with vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
  command="az backup policy show --name \"${policy_name}\" --vault-name \"${vault_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message      "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_secure   "Azure Backup Policy ${description} for policy \"${policy_name}\" with vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "Azure Backup Policy ${description} for policy \"${policy_name}\" with vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            fix_message "az backup policy update --name \"${policy_name}\" --vault-name \"${vault_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\""
            ;;
          *)
            fix_message "az backup policy update --name \"${policy_name}\" --vault-name \"${vault_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${correct_value}\""
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_insecure "Azure Backup Policy ${description} for policy \"${policy_name}\" with vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            fix_message "az backup policy update --name \"${policy_name}\" --vault-name \"${vault_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\""
            ;;
          *)
            fix_message "az backup policy update --name \"${policy_name}\" --vault-name \"${vault_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${correct_value}\""
            ;;
        esac
      fi
    else
      inc_secure "Azure Backup Policy ${description} for policy \"${policy_name}\" with vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
