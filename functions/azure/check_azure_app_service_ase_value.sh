#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_app_service_ase_value
#
# Check Azure App Service ASE value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_app_service_ase_value () {
  description="${1}"
  ase_name="${2}"
  sub_name="${3}"
  parameter_name="${4}"
  function="${5}"
  correct_value="${6}"
  print_function "check_azure_app_service_ase_value"
  verbose_message "${description} for App Service ASE ${ase_name} parameter ${parameter_name} is ${function} to ${correct_value}" "check"
  if [ -z "${sub_name}" ]; then
    command="az appservice ase show --name ${ase_name} --query \"${parameter_name}\" --output tsv"
  else
    command="az appservice ase show --name ${ase_name} --query \"[?contains(name, '${sub_name}')]\" --query \"${parameter_name}\" --output tsv"
  fi
  command_message "${command}"
  actual_value=$( eval "${command}" 2> /dev/null )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" != "${correct_value}" ]; then
      insecure_message "${description} for App Service ASE ${ase_name} parameter ${parameter_name} is not ${correct_value}"
    else
      secure_message   "${description} for App Service ASE ${ase_name} parameter ${parameter_name} is ${correct_value}"
    fi
  else
    if [ "${function}" = "ne" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        insecure_message "${description} for App Service ASE ${ase_name} parameter ${parameter_name} is ${correct_value}"
      else
        secure_message   "${description} for App Service ASE ${ase_name} parameter ${parameter_name} is not ${correct_value}"
      fi
    fi
  fi
}
