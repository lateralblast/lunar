#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_key_vault_value
#
# Check Azure Key Vault values
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

check_azure_key_vault_value () {
  resource_name="${1}"
  resource_group="${2}"
  parameter_name="${3}"
  function="${4}"
  correct_value="${5}"
  set_name="${6}"
  print_function  "check_azure_key_vault_value"
  verbose_message "Key vault with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az keyvault show --resource-group \"${resource_group}\" --name \"${resource_name}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
  command_message "${command}" "exec"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Key vault with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Key vault with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        verbose_message  "az keyvault update --resource-group ${resource_group} --name ${resource_name} ${set_name} ${correct_value}" "fix"
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Key vault with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        verbose_message  "az keyvault update --resource-group ${resource_group} --name ${resource_name} ${set_name} ${correct_value}" "fix"
      else
        if [ "${parameter_name}" = "properties.privateEndpointConnections" ]; then
          verbose_message  "1. To create an endpoint, run the following command:" "fix"
          verbose_message  "az network private-endpoint create --resource-group <resourceGroup> --vnet-name <vnetName> --subnet <subnetName> --name <PrivateEndpointName> \ " "fix"
          verbose_message  "--private-connection-resource-id \"/subscriptions/<AZURE SUBSCRIPTION ID>/resourceGroups/<resourceGroup>/providers/Microsoft.KeyVault/vaults/<keyVaultName>\" \ " "fix"
          verbose_message  "--group-ids vault --connection-name <privateLinkConnectionName> --location <azureRegion> --manual-request" "fix"
          verbose_message  "2. To manually approve the endpoint request, run the following command:" "fix"
          verbose_message  "az keyvault private-endpoint-connection approve --resource-group <resourceGroup> --vault-name <keyVaultName> –name <privateLinkName>" "fix"
          verbose_message  "3. Determine the Private Endpoint's IP address to connect the Key Vault to the Private DNS you have previously created:" "fix"
          verbose_message  "4. Look for the property networkInterfaces then id; the value must be placed in the variable <privateEndpointNIC> within step 7." "fix"
          verbose_message  "az network private-endpoint show -g <resourceGroupName> -n <privateEndpointName>" "fix"
          verbose_message  "5. Look for the property networkInterfaces then id; the value must be placed on <privateEndpointNIC> in step 7." "fix"
          verbose_message  "az network nic show --ids <privateEndpointName>" "fix"
          verbose_message  "6. Create a Private DNS record within the DNS Zone you created for the Private Endpoint:" "fix"
          verbose_message  "az network private-dns record-set a add-record -g <resourcecGroupName> -z "privatelink.vaultcore.azure.net" -n <keyVaultName> -a <privateEndpointNIC>" "fix"
          verbose_message  "7. nslookup the private endpoint to determine if the DNS record is correct:" "fix"
          verbose_message  "nslookup <keyVaultName>.vault.azure.net" "fix"
          verbose_message  "nslookup <keyVaultName>.privatelink.vaultcore.azure.net" "fix"
        fi
      fi
    else
      increment_secure   "Key vault with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
