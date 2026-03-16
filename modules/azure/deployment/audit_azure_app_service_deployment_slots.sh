#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_deployment_slots
#
# App Service Deployment Slots
# 2.2.1   Ensure 'Java version' is currently supported (if in use) - TBD
# 2.2.2   Ensure 'Python version' is currently supported (if in use) - TBD
# 2.2.3   Ensure 'PHP version' is currently supported (if in use) - TBD
# 2.2.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
# 2.2.5   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
# 2.2.6   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
# 2.2.7   Ensure 'HTTPS Only' is set to 'On' - TBD
# 2.2.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
# 2.2.9   Ensure end-to-end TLS encryption is enabled - TBD
# 2.2.10  Ensure 'Remote debugging' is set to 'Off' - TBD
# 2.2.11  Ensure incoming client certificates are enabled and required (if in use) - TBD
# 2.2.12  Ensure managed identities are configured - TBD
# 2.2.13  Ensure public network access is disabled - TBD
# 2.2.14  Ensure deployment slot is integrated with a virtual network - TBD
# 2.2.15  Ensure configuration is routed through the virtual network integration - TBD
# 2.2.16  Ensure all traffic is routed through the virtual network - TBD
# 2.2.17  Ensure cross-origin resource sharing does not allow all origins - TBD
#
# Refer to Section(s) 2.2.1-17 Page(s) 90-141 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_deployment_slots () {
  print_function "audit_azure_app_service_deployment_slots"
  check_message  "Azure App Service Deployment Slots"
  command="az webapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message  "No App Service Apps found"
    return
  fi
  # 2.2.1   Ensure 'Java version' is currently supported (if in use) - TBD
  audit_azure_app_service_deployment_slot_java_versions
  # 2.2.2   Ensure 'Python version' is currently supported (if in use) - TBD
  audit_azure_app_service_deployment_slot_python_versions
  # 2.2.3   Ensure 'PHP version' is currently supported (if in use) - TBD
  audit_azure_app_service_deployment_slot_php_versions
  # 2.2.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
  audit_azure_app_service_deployment_slot_basic_auth
  # 2.2.5   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
  audit_azure_app_service_deployment_slot_ftp_states
  # 2.2.6   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
  # 2.2.7   Ensure 'HTTPS Only' is set to 'On' - TBD
  audit_azure_app_service_deployment_slot_http_values
  # 2.2.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
  # 2.2.9   Ensure end-to-end TLS encryption is enabled - TBD
  audit_azure_app_service_deployment_slot_tls_values
  # 2.2.10  Ensure 'Remote debugging' is set to 'Off' - TBD
  audit_azure_app_service_deployment_slot_remote_debugging
  # 2.2.11  Ensure incoming client certificates are enabled and required (if in use) - TBD
  audit_azure_app_service_deployment_slot_client_certificates
  # 2.2.12  Ensure managed identities are configured - TBD
  audit_azure_app_service_deployment_slot_managed_identities
  # 2.2.13  Ensure public network access is disabled - TBD
  audit_azure_app_service_deployment_slot_public_network_access
  # 2.2.14  Ensure app is integrated with a virtual network - TBD
  # 2.2.15  Ensure configuration is routed through the virtual network integration - TBD
  audit_azure_app_service_deployment_slot_virtual_network_integration
  # 2.2.17  Ensure cross-origin resource sharing does not allow all origins - TBD
  audit_azure_app_service_deployment_slot_cors
  # 2.2.16  Ensure private endpoints are used to access App Service apps - TBD
  audit_azure_app_service_deployment_slot_private_endpoints
}
