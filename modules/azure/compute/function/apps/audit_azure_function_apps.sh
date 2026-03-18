#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_apps
#
# Function Apps
# 2.3.1   Ensure 'Java version' is currently supported (if in use) - TBD
# 2.3.2   Ensure 'Python version' is currently supported (if in use) - TBD
# 2.3.3   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
# 2.3.5   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
# 2.3.6   Ensure 'HTTPS Only' is set to 'On' - TBD
# 2.3.7   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
# 2.3.8   Ensure end-to-end TLS encryption is enabled - TBD
# 2.3.9   Ensure 'Remote debugging' is set to 'Off' - TBD
# 2.3.10  Ensure incoming client certificates are enabled and required (if in use) - TBD
# 2.3.11  Ensure 'App Service authentication' is set to 'Enabled' - TBD
# 2.3.12  Ensure managed identities are configured - TBD
# 2.3.13  Ensure public network access is disabled - TBD
# 2.3.14  Ensure function app is integrated with a virtual network - TBD
# 2.3.15  Ensure configuration is routed through the virtual network integration - TBD
# 2.3.16  Ensure all traffic is routed through the virtual network - TBD
# 2.3.17  Ensure cross-origin resource sharing does not allow all origins - TBD
#
# Refer to Section(s) 2.3.1-17 Page(s) 142- CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_apps () {
  print_function "audit_azure_functions_apps"
  check_message  "Azure Function Apps"
  command="az functionapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message "No Function Apps found"
    return
  fi
  # 2.3.1   Ensure 'Java version' is currently supported (if in use) - TBD
  audit_azure_function_app_java_versions
  # 2.3.2   Ensure 'Python version' is currently supported (if in use) - TBD
  audit_azure_function_app_python_versions
  # 2.3.3   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
  audit_azure_function_app_basic_authentication_publishing_credentials
  # 2.3.4   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
  audit_azure_function_app_ftp_states
  # 2.3.5   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
  # 2.3.6   Ensure 'HTTPS Only' is set to 'On' - TBD
  audit_azure_function_app_http_values
  # 2.3.7   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
  # 2.3.8   Ensure end-to-end TLS encryption is enabled - TBD
  audit_azure_function_app_tls_values
  # 2.3.9   Ensure 'Remote debugging' is set to 'Off' - TBD
  audit_azure_function_app_remote_debugging
  for app_id in ${app_ids}; do
    command="az functionapp show --id \"${app_id}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    # 2.3.10  Ensure incoming client certificates are enabled and required (if in use) - TBD
    check_azure_function_app_value "Client Certificates"                         "${app_id}" "${res_group}" "config"                             "web" "Microsoft.Web/sites" "clientCertEnabled"                 "eq" "true"                          "clientCertEnabled"                              ""
    # 2.3.11 Ensure 'App Service authentication' is set to 'Enabled' - TBD
    check_azure_function_app_value "App Service Authentication"                  "${app_id}" "${res_group}" "auth"                               "web" "Microsoft.Web/sites" "authSettings.enabled"              "eq" "true"                          "properties.authSettings.enabled"                ""
    # 2.3.12  Ensure managed identities are configured - TBD
    check_azure_function_app_value "Managed Identities"                          "${app_id}" "${res_group}" "config"                             "web" "identity"            "type"                              "eq" "${azure_managed_identity}"     ""                                               ""
    # 2.3.13  Ensure public network access is disabled - TBD
    check_azure_function_app_value "Public Network Access"                       "${app_id}" "${res_group}" "config"                             "web" "Microsoft.Web/sites" "publicNetworkAccess"               "eq" "Disabled"                      "properties.publicNetworkAccess"                 ""
    # 2.3.14  Ensure app is integrated with a virtual network - TBD
    check_azure_function_app_value "Virtual Network Integration"                 "${app_id}" "${res_group}" "config"                             "web" "" "virtualNetworkSubnetId"            "ne" ""                              ""                                               ""
    # 2.3.16  Ensure configuration is routed through the virtual network integration - TBD
    check_azure_function_app_value "VNet Image Pull"                             "${app_id}" "${res_group}" "config"                             "web" "Microsoft.Web/sites" "vnetRouteAllEnabled"               "eq" "true"                          "properties.vnetRouteAllEnabled"                 ""
    check_azure_function_app_value "VNet Content Share"                          "${app_id}" "${res_group}" "config"                             "web" "Microsoft.Web/sites" "vnetContentShareEnabled"           "eq" "true"                          "properties.vnetContentShareEnabled"             ""
    # 2.3.17  Ensure cross-origin resource sharing does not allow all origins - TBD
    check_azure_function_app_value "Cross-Origin Resource Sharing"               "${app_id}" "${res_group}" "config"                             "web" "cors"                "siteConfig.cors.allowedOrigins"    "ne" "*"                             "properties.cors.allowedOrigins"                 ""
  done
}
