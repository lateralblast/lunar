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
  elastic_san_id="${2}"
  elastic_san_name="${3}"
  resource_group="${4}"
  volume_group_name="${5}"
  query_string="${6}"
  function="${7}"
  correct_value="${8}"
  set_name="${9}"
  set_value="${10}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  if [ "${volume_group_name}" = "" ]; then
    short_name=$( basename "${elastic_san_id}" )
    print_function  "check_azure_elastic_san_value"
    verbose_message "${description} for Elastic SAN \"${short_name}\" has Parameter \"${query_string}\" \"${function}\" to \"${correct_value}\"" "check"
    command="az elastic-san show --id \"${elastic_san_id}\" --query \"${query_string}\" --output tsv 2> /dev/null"
    command_message "${command}"
    actual_value=$( eval "${command}" )
    if [ "${function}" = "eq" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        increment_secure   "${description} for Elastic SAN \"${short_name}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
      else
        increment_insecure "${description} for Elastic SAN \"${short_name}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
        if [ "${set_name}" != "" ]; then
          command="az elastic-san update --id \"${elastic_san_id}\" ${set_name} \"${set_value}\""
          verbose_message "${command}" "fix"
        fi
      fi
    else
      if [ "${function}" = "ne" ]; then
        if [ "${actual_value}" != "${correct_value}" ]; then
          increment_secure   "${description} for Elastic SAN \"${short_name}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
        else
          increment_insecure "${description} for Elastic SAN \"${short_name}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
          if [ "${set_name}" != "" ]; then
            command="az elastic-san update --id \"${elastic_san_id}\" ${set_name} \"${set_value}\""
            verbose_message "${command}" "fix"
          fi
        fi
      fi
    fi
  else
    command="az elastic-san volume-group show --resource-group \"${resource_group}\" --elastic-san \"${elastic_san_name}\" --name \"${volume_group_name}\" --query \"${query_string}\" --output tsv 2> /dev/null"
    command_message "${command}"
    actual_value=$( eval "${command}" )
    if [ "${function}" = "eq" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        increment_secure   "${description} for Elastic SAN \"${elastic_san_name}\" Volume Group \"${volume_group_name}\" has Parameter \"${query_string}\" \"${function}\" to \"${correct_value}""
      else
        increment_insecure "${description} for Elastic SAN \"${elastic_san_name}\" Volume Group \"${volume_group_name}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}""
        if [ "${set_name}" != "" ]; then
          command="az elastic-san volume-group update --resource-group \"${resource_group}\" --elastic-san \"${elastic_san_name}\" --name \"${volume_group_name}\" ${set_name} \"${set_value}\""
          verbose_message "${command}" "fix"
        fi
      fi
    else
      if [ "${function}" = "ne" ]; then
        if [ "${actual_value}" != "${correct_value}" ]; then
          increment_secure   "${description} for Elastic SAN \"${elastic_san_name}\" Volume Group \"${volume_group_name}\" has \"${query_string}\" \"${function}\" to \"${correct_value}""
        else
          increment_insecure "${description} for Elastic SAN \"${elastic_san_name}\" Volume Group \"${volume_group_name}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}""
          if [ "${set_name}" != "" ]; then
            command="az elastic-san volume-group update --resource-group \"${resource_group}\" --elastic-san \"${elastic_san_name}\" --name \"${volume_group_name}\" ${set_name} \"${set_value}\""
            verbose_message "${command}" "fix"
          fi
        fi
      fi
    fi
  fi
}
