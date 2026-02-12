#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_elastic_san_value
#
# Check Azure Elastic SAN Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_elastic_san_value () {
  description="${1}"
  elastic_san="${2}"
  query_string="${3}"
  function="${4}"
  correct_value="${5}"
  set_name="${6}"
  set_value="${7}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  short_name=$( basename "${elastic_san}" )
  print_function  "check_azure_elastic_san_value"
  verbose_message "${description} for Elastic SAN \"${short_name}\" has Parameter \"${query_string}\" \"${function}\" to \"${correct_value}\"" "check"
  command="az elastic-san show --id \"${elastic_san}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "${description} for Elastic SAN \"${short_name}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for Elastic SAN \"${short_name}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
      if [ "${set_name}" != "" ]; then
        command="az elastic-san update --id \"${elastic_san}\" ${set_name} \"${set_value}\""
        verbose_message "${command}" "fix"
      fi
    fi
  elif [ "${function}" = "ne" ]; then
    if [ "${actual_value}" != "${correct_value}" ]; then
      increment_secure   "${description} for Elastic SAN \"${short_name}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for Elastic SAN \"${short_name}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
      if [ "${set_name}" != "" ]; then
        command="az elastic-san update --id \"${elastic_san}\" ${set_name} \"${set_value}\""
        verbose_message "${command}" "fix"
      fi
    fi
  fi
}
