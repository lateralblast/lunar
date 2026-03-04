#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_waf_value
#
# Check Azure WAF value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_waf_value () {
  waf_name="${1}"
  policy_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  parameter_name="${7}"
  parameter_value="${8}"
  waf_id="${waf_name}"
  print_function "check_azure_waf_value"
  if [ "${policy_name}" = "waf-policy" ]; then
    check_message "Azure WAF \"${waf_id}\" has \"${query_string}\" ${function} to \"${correct_value}\""
    if [ "${query_string}" = "managedRules.managedRuleSets" ]; then
      command="az network application-gateway ${policy_name} show --id \"${waf_id}\" --query \"${query_string}\" | grep \"${correct_value}\" | cut -f4 -d\\\" 2> /dev/null"
    else
      command="az network application-gateway ${policy_name} show --id \"${waf_id}\" --query \"${query_string}\" --output tsv 2> /dev/null"
    fi
    command_message      "${command}"
    actual_value=$( eval "${command}" )
    if [ "${function}" = "ne" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        inc_insecure "Azure WAF \"${waf_id}\" does not have \"${query_string}\" ${function} to \"${correct_value}\""
      else
        inc_secure   "Azure WAF \"${waf_id}\" has \"${query_string}\" ${function} to \"${correct_value}\""
      fi
    else
      if [ "${actual_value}" = "${correct_value}" ]; then
        inc_secure   "Azure WAF \"${waf_id}\" has \"${query_string}\" ${function} to \"${correct_value}\""
      else
        inc_insecure "Azure WAF \"${waf_id}\" does not have \"${query_string}\" ${function} to \"${correct_value}\""
        if [ "${parameter_name}" != "" ]; then
          case "${parameter_name}" in
            "--"*)
              fix_message "az network application-gateway ${policy_name} update --id \"${waf_id}\" \"${parameter_name}\" \"${parameter_value}\""
              ;;
            *)
              fix_message "az network application-gateway ${policy_name} update --id \"${waf_id}\" --set \"${parameter_name}\"=\"\"${parameter_value}\""
              ;;
          esac
        fi
      fi
    fi
  else
    if [ "${policy_name}" = "" ]; then
      policy_string=""
      check_message "Azure WAF \"${waf_name}\" in Resource Group \"${resource_group}\" has \"${query_string}\" ${function} to \"${correct_value}\""
      command="az network application-gateway show --name \"${waf_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
    else
      policy_string=" Policy \"${policy_name}\""
      check_message "Azure WAF Policy \"${policy_name}\" in Resource Group \"${resource_group}\" has \"${query_string}\" ${function} to \"${correct_value}\""
      command="az network application-gateway ${policy_name} show --name \"${waf_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
    fi
    command_message      "${command}"
    actual_value=$( eval "${command}" )
    if [ "${function}" = "ne" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        inc_insecure "Azure WAF \"${waf_name}\"${policy_string} in Resource Group \"${resource_group}\" does not have \"${query_string}\" ${function} to \"${correct_value}\""
      else
        inc_secure   "Azure WAF \"${waf_name}\"${policy_string} in Resource Group \"${resource_group}\" has \"${query_string}\" ${function} to \"${correct_value}\""
      fi
    else
      if [ "${actual_value}" = "${correct_value}" ]; then
        inc_secure   "Azure WAF \"${waf_name}\"${policy_string} in Resource Group \"${resource_group}\" has \"${query_string}\" ${function} to \"${correct_value}\""
      else
        inc_insecure "Azure WAF \"${waf_name}\"${policy_string} in Resource Group \"${resource_group}\" does not have \"${query_string}\" ${function} to \"${correct_value}\""
        if [ "${parameter_name}" != "" ]; then
          case "${parameter_name}" in
            "--"*)
              fix_message "az network application-gateway ${policy_name} update --name \"${waf_name}\" --resource-group \"${resource_group}\" \"${parameter_name}\" \"${parameter_value}\""
              ;;
            *)
              fix_message "az network application-gateway ${policy_name} update --name \"${waf_name}\" --resource-group \"${resource_group}\" --set \"${parameter_name}\"=\"${parameter_value}\""
              ;;
          esac
        fi
      fi
    fi
  fi
}
