#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_deployment_slots
#
# Functions Deployment Slots
# 2.4.1   Ensure 'Java version' is currently supported (if in use) - TBD
# 2.4.2   Ensure 'Python version' is currently supported (if in use) - TBD
# 2.4.3   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
# 2.4.4   Ensure 'FTP state' is set to 'FTPS only' or 'Disabled' - TBD
# 2.4.5   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
# 2.4.6   Ensure 'HTTPS Only' is set to 'On' - TBD
# 2.4.7   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
# 2.4.8   Ensure end-to-end TLS encryption is enabled - TBD
# 2.4.9   Ensure 'Remote debugging' is set to 'Off' - TBD
# 2.4.10  Ensure incoming client certificates are enabled and required (if in use) - TBD
# 2.4.11  Ensure managed identities are configured - TBD
# 2.4.12  Ensure public network access is disabled - TBD
# 2.4.13  Ensure deployment slot is integrated with a virtual network - TBD
# 2.4.14  Ensure configuration is routed through the virtual network integration - TBD
# 2.4.15  Ensure all traffic is routed through the virtual network - TBD
# 2.4.16  Ensure cross-origin resource sharing does not allow all origins - TBD
#
# Refer to Section(s) 2.4.1-16 Page(s) 192-237 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_deployment_slots () {
  print_function "audit_azure_function_deployment_slots"
  check_message  "Azure Function App Deployment Slots"
  command="az functionapp list --query \"[].name\" --output tsv"
  command_message   "${command}"
  app_names=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_names}" ]; then
    info_message "No Function App Apps found"
    return
  fi
  for app_name in ${app_names}; do
    command="az functionapp show --name \"${app_name}\" --query \"resourceGroup\" --output tsv"
    command_message    "${command}"
    res_group=$( eval  "${command}" )
    command="az functionapp deployment slot list --name \"${app_name}\" --resource-group \"${res_group}\" --query \"[].name\" --output tsv"
    command_message    "${command}"
    slot_names=$( eval "${command}" 2> /dev/null )
    if [ -z "${slot_names}" ]; then
      info_message "No Function App Deployment Slots found"
      return
    fi
    # 2.4.1   Ensure 'Java version' is currently supported (if in use) - TBD
    audit_azure_function_deployment_slots_java_versions
    # 2.4.2   Ensure 'Python version' is currently supported (if in use) - TBD
    audit_azure_function_deployment_slots_python_versions
    # 2.4.3   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
    audit_azure_function_deployment_slots_basic_authentication_publishing_credentials
    # 2.4.4   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
    audit_azure_function_deployment_slots_ftp_states
    # 2.4.5   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
    # 2.4.6   Ensure 'HTTPS Only' is set to 'On' - TBD
    audit_azure_function_deployment_slots_http_values
    # 2.4.7   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
    # 2.4.8   Ensure end-to-end TLS encryption is enabled - TBD
    audit_azure_function_deployment_slots_tls_values
    # 2.4.9   Ensure 'Remote debugging' is set to 'Off' - TBD
    audit_azure_function_deployment_slots_remote_debugging
    # 2.4.10  Ensure incoming client certificates are enabled and required (if in use) - TBD
    audit_azure_function_deployment_slots_client_certificates
    # 2.4.11  Ensure managed identities are configured - TBD
    audit_azure_function_deployment_slots_managed_identities
    # 2.4.12  Ensure public network access is disabled - TBD
    audit_azure_function_deployment_slots_public_network_access
    # 2.4.13  Ensure app is integrated with a virtual network - TBD
    # 2.4.14  Ensure configuration is routed through the virtual network integration - TBD
    audit_azure_function_deployment_slots_virtual_network_integration
    for slot_name in ${slot_names}; do
      # 2.4.15  Ensure cross-origin resource sharing does not allow all origins - TBD
      check_azure_function_deployment_slot_value "Cross-Origin Resource Sharing"               "${slot_id}" "${app_name}" "${res_group}" "config"                             "web" "cors"                "siteConfig.cors.allowedOrigins"    "ne" "*"                             "properties.cors.allowedOrigins"        ""
    done
  done
  # 2.4.16  Ensure private endpoints are used to access App Service apps - TBD
  command="az webapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  for app_id in ${app_ids}; do
    check_azure_network_private_endpoint_value "${app_id}" "[*].privateLinkServiceConnections[*].[privateLinkServiceId,privateLinkServiceConnectionState.status]"   "eq" "Approved"
  done
}
