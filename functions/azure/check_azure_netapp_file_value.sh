#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_netapp_file_value
#
# Check Azure NetApp File value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_netapp_file_value () {
  print_function  "check_azure_netapp_file_value"
  description="${1}"
  storage_account="${2}"
  resource_group="${3}"
  parameter_name="${4}"
  function="${5}"
  correct_value="${6}"
  verbose_message "${description} for Shares on Storage Account \"${storage_account}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az netappfiles account show --account-name \"${storage_account}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "Shares for Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\""
  else
    increment_insecure "Shares for Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\""
    if [ "${parameter_name}" = "encryptionKeySource" ]; then
      verbose_message "az keyvault set-policy --name <keyvault-name> --object-id <netapp-service-principal-object-id> --key-permissions get wrapKey unwrapKey" "fix"
      verbose_message "az netappfiles account encryption-key-source update --resource-group <resource-group> --account-name <account-name> --encryption-key-source Microsoft.KeyVault --key-vault-key-uri <key-vault-key-uri>" "fix"
    else  
      if [ ! -z "${set_name}" ]; then
        case "${set_name}" in
          "--"*)
            if [ "${retention_days}" = "" ]; then
              verbose_message  "az netappfiles account update --name ${storage_account} --resource-group ${resource_group} ${set_name} ${correct_value}" "fix"
            else
              verbose_message  "az netappfiles account update --name ${storage_account} --resource-group ${resource_group} ${set_name} ${correct_value} --retention-days ${retention_days}" "fix"
            fi
            ;;
          *)
            verbose_message    "az netappfiles account update --name ${storage_account} --resource-group ${resource_group} --set ${set_name}=${correct_value}" "fix"
            ;;
        esac
      fi
    fi
  fi
}
