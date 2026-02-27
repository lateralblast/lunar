#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_container_instance_value
#
# Check Azure Container Instance value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_container_instance_value () {
  description="${1}"
  container_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  print_function  "check_azure_container_instance_value"
  verbose_message "${description} for Container Instance \"${container_name}\" in resource group \"${resource_group}\" has parameter \"${query_string}\" \"${function}\" to \"${correct_value}\"" "check"
  command="az container show --name ${container_name} --resource-group ${resource_group} --query '${query_string}' --output tsv 2> /dev/null"
  command_message "$command"
  actual_value=$(eval "$command")
  if [ "${actual_value}" = "${correct_value}" ]; then
    secure_message "${description} for Container Instance \"${container_name}\" in resource group \"${resource_group}\" has parameter \"${query_string}\" \"${function}\" to \"${correct_value}\""
  else
    insecure_message "${description} for Container Instance \"${container_name}\" in resource group \"${resource_group}\" has parameter \"${query_string}\" \"${function}\" to \"${correct_value}\""
    if [ ! "${set_name}" = "" ]; then
      case "${set_name}" in
        "--"*)
          verbose_message  "az container update --name \"${container_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\"" "fix"
          ;;
        *)
          verbose_message  "az container update --name \"${container_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${correct_value}\"" "fix"
          ;;
      esac
    fi
  fi
}
