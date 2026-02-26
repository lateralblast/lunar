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
  verbose_message "Azure App Service Deployment Slots" "check"
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
    command="az webapp deployment slot list --name \"${app_name}\" --resource-group \"${resource_group}\" --query \"[].name\" --output tsv"
    command_message "${command}"
    slot_names=$( eval "${command}" 2> /dev/null )
    if [ -z "${slot_names}" ]; then
      verbose_message "No App Service Deployment Slots found" "info"
      return
    fi
    for slot_name in ${slot_names}; do
      # 2.2.1   Ensure 'Java version' is currently supported (if in use) - TBD
      check_azure_app_service_deployment_slot_value "Java Version"                                "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "javaVersion"                       "eq" "${azure_java_version}"         "--java-version"                                 ""
      check_azure_app_service_deployment_slot_value "Java Container Version"                      "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "javaContainerVersion"              "eq" "${azure_java_version}"         "--java-container-version"                       ""
      # 2.2.2   Ensure 'Python version' is currently supported (if in use) - TBD
      check_azure_app_service_deployment_slot_value "Python Version"                              "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "pythonVersion"                     "eq" "${azure_python_version}"       "--python-version"                               ""
      # 2.2.3   Ensure 'PHP version' is currently supported (if in use) - TBD
      check_azure_app_service_deployment_slot_value "PHP Version"                                 "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "phpVersion"                        "eq" "${azure_php_version}"          "--php-version"                                  ""
      # 2.2.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
      check_azure_app_service_deployment_slot_value "Basic Authentication Publishing Credentials" "${app_name}" "${slot_name}" "${resource_group}" "basicPublishingCredentialsPolicies" "ftp" "Microsoft.Web/sites" "properties.allow"                        "eq" "false"          ""                                  ""
      check_azure_app_service_deployment_slot_value "Basic Authentication Publishing Credentials" "${app_name}" "${slot_name}" "${resource_group}" "basicPublishingCredentialsPolicies" "scm" "Microsoft.Web/sites" "properties.allow"                        "eq" "false"          ""                                  ""
      # 2.2.5   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
      check_azure_app_service_deployment_slot_value "FTP State"                                   "${app_name}" "${slot_name}" "${resource_group}" "config"                             "ftp" "Microsoft.Web/sites" "ftpState"                          "eq" "${azure_ftp_state}"            "--ftp-state"                                    ""
      # 2.2.6   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
      check_azure_app_service_deployment_slot_value "HTTP Version"                                "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "http20Enabled"                     "eq" "true"                          "--http20-enabled"                               ""
      # 2.2.7   Ensure 'HTTPS Only' is set to 'On' - TBD
      check_azure_app_service_deployment_slot_value "HTTPS Only"                                  "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "httpsOnly"                         "eq" "true"                          "httpsOnly"                                      ""
      # 2.2.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
      check_azure_app_service_deployment_slot_value "Minimum Inbound TLS Version"                 "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "minTlsVersion"                     "eq" "1.2"                           "--min-tls-version"                              ""
      # 2.2.9   Ensure end-to-end TLS encryption is enabled - TBD
      check_azure_app_service_deployment_slot_value "End-to-End TLS Encryption"                   "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "endToEndEncryptionEnabled"         "eq" "true"                          "properties.endToEndEncryptionEnabled"           ""
      # 2.2.10  Ensure 'Remote debugging' is set to 'Off' - TBD
      check_azure_app_service_deployment_slot_value "Remote Debugging"                            "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "remoteDebuggingEnabled"            "eq" "false"                         "--remote-debugging-enabled"                     ""
      # 2.2.11  Ensure incoming client certificates are enabled and required (if in use) - TBD
      check_azure_app_service_deployment_slot_value "Client Certificates"                         "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "clientCertEnabled"                 "eq" "true"                          "clientCertEnabled"                              ""
      # 2.2.12  Ensure managed identities are configured - TBD
      check_azure_app_service_deployment_slot_value "Managed Identities"                          "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "identity"            "type"                              "eq" "${azure_managed_identity}"     ""                                               ""
      # 2.2.13  Ensure public network access is disabled - TBD
      check_azure_app_service_deployment_slot_value "Public Network Access"                       "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "publicNetworkAccess"               "eq" "Disabled"                      "properties.publicNetworkAccess"                 ""
      # 2.2.14  Ensure app is integrated with a virtual network - TBD
      check_azure_app_service_deployment_slot_value "Virtual Network Integration"                 "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "virtualNetworkSubnetId"            "ne" ""                              ""                                               ""
      # 2.2.15  Ensure configuration is routed through the virtual network integration - TBD
      check_azure_app_service_deployment_slot_value "VNet Image Pull"                             "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "vnetRouteAllEnabled"               "eq" "true"                          "properties.vnetRouteAllEnabled"                 ""
      check_azure_app_service_deployment_slot_value "VNet Content Share"                          "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "Microsoft.Web/sites" "vnetContentShareEnabled"           "eq" "true"                          "properties.vnetContentShareEnabled"             ""
      # 2.2.17  Ensure cross-origin resource sharing does not allow all origins - TBD
      check_azure_app_service_deployment_slot_value "Cross-Origin Resource Sharing"               "${app_name}" "${slot_name}" "${resource_group}" "config"                             "web" "cors"                "siteConfig.cors.allowedOrigins"    "ne" "*"                             "properties.cors.allowedOrigins"                 ""
    done
  done
  # 2.2.16  Ensure private endpoints are used to access App Service apps - TBD
  command="az webapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  for app_id in ${app_ids}; do
    check_azure_network_private_endpoint_value "App Service App" "${app_id}" "[*].privateLinkServiceConnections[*].[privateLinkServiceId,privateLinkServiceConnectionState.status]"   "eq" "Approved"
  done
}
