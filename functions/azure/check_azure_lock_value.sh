#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_lock_value
#
# Check Azure Lock value
#
# This requires the Azure CLI to be installed and configured
#

check_azure_lock_value () {
  print_function  "check_azure_lock_value"
  verbose_message "Azure Lock Value" "check"
  lock_name="$1"
  resource_group="$2"
  resource_type="$3"
  query_string="$4"
  function="$5"
  correct_value="$6"
  set_name="$7"
  command="az lock show --name \"${lock_name}\" --resource-group \"${resource_group}\" --resource-type \"${resource_type}\" --query \"${query_string}\" --output tsv"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "Lock \"${lock_name}\" in resource group \"${resource_group}\" resource type \"${resource_type}\" parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "ok"
  else
    increment_insecure "Lock \"${lock_name}\" in resource group \"${resource_group}\" resource type \"${resource_type}\" parameter \"${query_string}\" is \"${function}\" to \"${actual_value}\" instead of \"${correct_value}\"" "fail"
    if [ "${set_name}" != "" ]; then
      case "${set_name}" in
        *"--"*)
          verbose_message "az lock update --name \"${lock_name}\" --resource-group \"${resource_group}\" --resource-type \"${resource_type}\" --set \"${set_name}\" \"${correct_value}\"" "fix"
          ;;
        *)
          verbose_message "az lock update --name \"${lock_name}\" --resource-group \"${resource_group}\" --resource-type \"${resource_type}\" \"${set_name}\"=\"${correct_value}\"" "fix"
          ;;
      esac
    fi
  fi
}
