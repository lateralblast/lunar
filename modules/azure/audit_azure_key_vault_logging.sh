#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_logging
#
# Check Azure Key Vault Logging
#
# 6.1.1.4  Ensure that logging for Azure Key Vault is 'Enabled'
# Refer to Section(s) 6.1.1.4 Page(s) 207-10 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_key_vault_logging () {
  print_function  "audit_azure_key_vault_logging"
  verbose_message "Azure Key Vault Logging" "check"
  command="az keyvault list --query \"[].id\" --output tsv 2>/dev/null"
  command_message "${command}" "exec"
  key_vault_ids=$( eval "${command}" )
  for key_vault_id in ${key_vault_ids}; do
    command="az monitor diagnostic-settings list --resource ${key_vault_id} --query \"[].name\" --output tsv 2>/dev/null"
    command_message "${command}" "exec"
    resource_names=$( eval "${command}" )
    for resource_name in ${resource_names}; do
      command="az monitor diagnostic-settings show --resource ${key_vault_id} --name ${resource_name} --query \"logs\" --output tsv 2>/dev/null"
      command_message "${command}" "exec"
      az monitor diagnostic-settings show --resource ${key_vault_id} --name ${resource_name} --query "logs" --output tsv 2>/dev/null |
      while read -r line; do
        category=$( echo "${line}" | awk '{print $1}' )
        enabled=$( echo "${line}" | awk '{print $2}' )
        if [ "${enabled}" = "True" ]; then
          increment_secure "Key Vault ${resource_name} logging enabled for ${category}"
        else
          increment_insecure "Key Vault ${resource_name} logging disabled for ${category}"
        fi
      done
    done
  done
}
