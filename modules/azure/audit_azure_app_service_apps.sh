#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_apps
#
# Check Azure App Service Apps
#
# 2.1.1   Ensure 'Java version' is currently supported (if in use) - TBD
# 2.1.2   Ensure 'Python version' is currently supported (if in use) - TBD
# 2.1.3   Ensure 'PHP version' is currently supported (if in use) - TBD
# 2.1.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
# 2.1.5   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
# 2.1.6   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
# 2.1.7   Ensure 'HTTPS Only' is set to 'On' - TBD
# 2.1.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
# 2.1.9   Ensure end-to-end TLS encryption is enabled - TBD
# 2.1.10  Ensure 'Remote debugging' is set to 'Off' - TBD
# 2.1.11  Ensure incoming client certificates are enabled and required (if in use) - TBD
# 2.1.12  Ensure 'App Service authentication' is set to 'Enabled' - TBD
# 2.1.13  Ensure managed identities are configured - TBD
# 2.1.14  Ensure public network access is disabled - TBD
# 2.1.15  Ensure App Service plan SKU supports private endpoints - TBD
# 2.1.16  Ensure private endpoints are used to access App Service apps - TBD
# 2.1.17  Ensure private endpoints used to access App Service apps use private DNS zones - TBD
# 2.1.18  Ensure app is integrated with a virtual network - TBD
# 2.1.19  Ensure configuration is routed through the virtual network integration - TBD
# 2.1.20  Ensure all traffic is routed through the virtual network - TBD
# 2.1.21  Ensure cross-origin resource sharing does not allow all origins - TBD
#
# Refer to Section(s) 2.1.1-21 Page(s) 23-89 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_apps () {
  print_function "audit_azure_app_service_apps"
  verbose_message "Azure App Service Apps" "check"
  command="az webapp list --query \"[].name\" --output tsv"
  command_message "${command}"
  app_names=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_names}" ]; then
    verbose_message "No App Service Apps found" "info"
    return
  fi
  for app_name in ${app_names}; do
    command="az webapp show --name \"${app_name}\" --query \"resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    # 2.1.1   Ensure 'Java version' is currently supported (if in use) - TBD
    check_azure_app_service_app_value "Java Version"                  "${app_name}" "${resource_group}" ""                    "javaVersion"                       "eq" "${azure_java_version}"         "--java-version"                                 ""
    check_azure_app_service_app_value "Java Container Version"        "${app_name}" "${resource_group}" ""                    "javaContainerVersion"              "eq" "${azure_java_version}"         "--java-container-version"                       ""
    # 2.1.2   Ensure 'Python version' is currently supported (if in use) - TBD
    check_azure_app_service_app_value "Python Version"                "${app_name}" "${resource_group}" ""                    "pythonVersion"                     "eq" "${azure_python_version}"       "--python-version"                               ""
    # 2.1.3   Ensure 'PHP version' is currently supported (if in use) - TBD
    check_azure_app_service_app_value "PHP Version"                   "${app_name}" "${resource_group}" ""                    "phpVersion"                        "eq" "${azure_php_version}"          "--php-version"                                  ""
    # 2.1.5   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
    check_azure_app_service_app_value "FTP State"                     "${app_name}" "${resource_group}" ""                    "ftpState"                          "eq" "${azure_ftp_state}"            "--ftp-state"                                    ""
    # 2.1.6   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
    check_azure_app_service_app_value "HTTP Version"                  "${app_name}" "${resource_group}" ""                    "http20Enabled"                     "eq" "true"                          "--http20-enabled"                               ""
    # 2.1.7   Ensure 'HTTPS Only' is set to 'On' - TBD
    check_azure_app_service_app_value "HTTPS Only"                    "${app_name}" "${resource_group}" ""                    "httpsOnly"                         "eq" "true"                          "httpsOnly"                                      ""
    # 2.1.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
    check_azure_app_service_app_value "Minimum Inbound TLS Version"   "${app_name}" "${resource_group}" ""                    "minTlsVersion"                     "eq" "1.2"                           "--min-tls-version"                              ""
    # 2.1.9   Ensure end-to-end TLS encryption is enabled - TBD
    check_azure_app_service_app_value "End-to-End TLS Encryption"     "${app_name}" "${resource_group}" "Microsoft.Web/sites" "endToEndEncryptionEnabled"         "eq" "true"                          "properties.endToEndEncryptionEnabled"           ""
    # 2.1.10  Ensure 'Remote debugging' is set to 'Off' - TBD
    check_azure_app_service_app_value "Remote Debugging"              "${app_name}" "${resource_group}" ""                    "remoteDebuggingEnabled"            "eq" "false"                         "--remote-debugging-enabled"                     ""
    # 2.1.11  Ensure incoming client certificates are enabled and required (if in use) - TBD
    check_azure_app_service_app_value "Client Certificates"           "${app_name}" "${resource_group}" "Microsoft.Web/sites" "clientCertEnabled"                 "eq" "true"                          "clientCertEnabled"                              ""
    # 2.1.12  Ensure 'App Service authentication' is set to 'Enabled' - TBD
    check_azure_app_service_app_value "App Service Auth v1"           "${app_name}" "${resource_group}" "auth"                "enabled"                           "eq" "true"                          "--enabled"                                      ""
    check_azure_app_service_app_value "App Service Auth v2"           "${app_name}" "${resource_group}" "auth"                "platform.enabled"                  "eq" "true"                          "--enabled"                                      ""
    # 2.1.13  Ensure managed identities are configured - TBD
    check_azure_app_service_app_value "Managed Identities"            "${app_name}" "${resource_group}" "identity"            "type"                              "eq" "${azure_managed_identity}"     ""                                               ""
    # 2.1.14  Ensure public network access is disabled - TBD
    check_azure_app_service_app_value "Public Network Access"         "${app_name}" "${resource_group}" ""                    "publicNetworkAccess"               "eq" "Disabled"                      "properties.publicNetworkAccess"                 ""
    # 2.1.17  Ensure private endpoints used to access App Service apps use private DNS zones - TBD
    check_azure_app_service_app_value "Private DNS Zones"             "${app_name}" "${resource_group}" "Microsoft.Web/sites" "dnsConfiguration.dnsServers"       "ne" ""                              ""                                               ""
    # 2.1.18  Ensure app is integrated with a virtual network - TBD
    check_azure_app_service_app_value "Virtual Network Integration"   "${app_name}" "${resource_group}" ""                    "virtualNetworkSubnetId"            "ne" ""                              ""                                               ""
    # 2.1.19  Ensure configuration is routed through the virtual network integration - TBD
    # 2.1.20  Ensure all traffic is routed through the virtual network - TBD
    check_azure_app_service_app_value "VNet Image Pull"               "${app_name}" "${resource_group}" "Microsoft.Web/sites" "vnetRouteAllEnabled"               "eq" "true"                          "properties.vnetRouteAllEnabled"                 ""
    check_azure_app_service_app_value "VNet Content Share"            "${app_name}" "${resource_group}" "Microsoft.Web/sites" "vnetContentShareEnabled"           "eq" "true"                          "properties.vnetContentShareEnabled"             ""
    # 2.1.21  Ensure cross-origin resource sharing does not allow all origins - TBD
    check_azure_app_service_app_value "Cross-Origin Resource Sharing" "${app_name}" "${resource_group}" "cors"                "siteConfig.cors.allowedOrigins"    "ne" "*"                             "properties.cors.allowedOrigins"                 ""
    # 2.1.15  Ensure App Service plan SKU supports private endpoints - TBD
    command="az webapp show --name \"${app_name}\" --resource-group \"${resource_group}\" --query \"appServicePlanId\" --output tsv"
    command_message "${command}"
    app_plans=$( eval "${command}" )
    for app_plan in ${app_plans}; do
      check_azure_app_service_plan_value "App Service Plan SKU"       "${app_plan}" "${resource_group}" ""    "sku.tier" "eq" "${azure_sku_tier}" "--sku" ""
    done
    # 2.1.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
    check_azure_basic_authentication_publishing_credential_value      "${app_name}" "${resource_group}" "ftp" "Microsoft.Web" "basicPublishingCredentialsPolicies" "properties.allow" "eq" "false"     "--auth-settings.publishing-credentials-enabled" ""
    check_azure_basic_authentication_publishing_credential_value      "${app_name}" "${resource_group}" "scm" "Microsoft.Web" "basicPublishingCredentialsPolicies" "properties.allow" "eq" "false"     "--auth-settings.publishing-credentials-enabled" ""
  done
  # 2.1.16  Ensure private endpoints are used to access App Service apps - TBD
  command="az webapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  for app_id in ${app_ids}; do
    check_azure_network_private_endpoint_value "App Service App" "${app_id}" "[*].privateLinkServiceConnections[*].[privateLinkServiceId,privateLinkServiceConnectionState.status]"   "eq" "Approved"
  done
}
