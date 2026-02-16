#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_backup_vault_value
#
# Check Azure Backup values
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_backup_vault_value () {
  description="${1}"
  vault_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  set_name="${7}"
  print_function  "check_azure_backup_vault_value"
  verbose_message "Azure Backup Vault ${description} for vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az dataprotection backup-vault show --name \"${vault_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Azure Backup Vault ${description} for vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Azure Backup Vault ${description} for vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ "${query_string}" = "properties.encryption.keyUri" ]; then
        verbose_message "az keyvault set-policy --name <keyvault-name> --object-id <vault-managed-identity-object-id> --key-permissions get wrapKey unwrapKey" "fix"
        verbose_message "az backup vault encryption enable --resource-group <resource-group> --vault-name <vault-name> --key-uri <key-vault-key-uri>"          "fix"
      else
        if [ ! "${set_name}" = "" ]; then
          case "${set_name}" in
            "--"*)
              verbose_message  "az backup vault update --name \"${vault_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\"" "fix"
              ;;
            *)
              verbose_message  "az backup vault update --name \"${vault_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${correct_value}\"" "fix"
              ;;
          esac
        fi
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Azure Backup Vault ${description} for vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ "${query_string}" = "properties.encryption.keyUri" ]; then
        verbose_message "az keyvault set-policy --name <keyvault-name> --object-id <vault-managed-identity-object-id> --key-permissions get wrapKey unwrapKey" "fix"
        verbose_message "az backup vault encryption enable --resource-group <resource-group> --vault-name <vault-name> --key-uri <key-vault-key-uri>"          "fix"
      else
        if [ ! "${set_name}" = "" ]; then
          case "${set_name}" in
            "--"*)
              verbose_message  "az backup vault update --name \"${vault_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\"" "fix"
              ;;
            *)
              verbose_message  "az backup vault update --name \"${vault_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${correct_value}\"" "fix"
              ;;
          esac
        fi
      fi
    else
      increment_secure   "Azure Backup Vault ${description} for vault \"${vault_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
