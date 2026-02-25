#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_apps
#
# Check Azure App Service Apps
#
# 2.1.1   Ensure 'Java version' is currently supported (if in use) 
# 2.1.2   Ensure 'Python version' is currently supported (if in use) 
# 2.1.3   Ensure 'PHP version' is currently supported (if in use)
# 2.1.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled'
# 2.1.5   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' 
# 2.1.6   Ensure 'HTTP version' is set to '2.0' (if in use)
# 2.1.7   Ensure 'HTTPS Only' is set to 'On'
# 2.1.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher
# 2.1.9   Ensure end-to-end TLS encryption is enabled
# 2.1.10  Ensure 'Remote debugging' is set to 'Off'
# 2.1.11  Ensure incoming client certificates are enabled and required (if in use)
# 2.1.12  Ensure 'App Service authentication' is set to 'Enabled' 
# 2.1.13  Ensure managed identities are configured
# 2.1.14  Ensure public network access is disabled
# 2.1.15  Ensure App Service plan SKU supports private endpoints 
# 2.1.16  Ensure private endpoints are used to access App Service apps
# 2.1.17  Ensure private endpoints used to access App Service apps use private DNS zones
# 2.1.18  Ensure app is integrated with a virtual network
# 2.1.19  Ensure configuration is routed through the virtual network integration
# 2.1.20  Ensure all traffic is routed through the virtual network
# 2.1.21  Ensure cross-origin resource sharing does not allow all origins
#
# Refer to Section(s) 2 Page(s) 23-89 CIS Microsoft Azure Compute Services Benchmark v2.0.0
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
    # 2.1.1   Ensure 'Java version' is currently supported (if in use) 
    check_azure_app_service_app_value "Java Version"                "${app_name}" "${resource_group}" "javaVersion"          "eq" "${azure_java_version}"   "--java-version"           ""
    check_azure_app_service_app_value "Java Container Version"      "${app_name}" "${resource_group}" "javaContainerVersion" "eq" "${azure_java_version}"   "--java-container-version" ""
    # 2.1.2   Ensure 'Python version' is currently supported (if in use) 
    check_azure_app_service_app_value "Python Version"              "${app_name}" "${resource_group}" "pythonVersion"        "eq" "${azure_python_version}" "--python-version"         ""
    # 2.1.3   Ensure 'PHP version' is currently supported (if in use)
    check_azure_app_service_app_value "PHP Version"                 "${app_name}" "${resource_group}" "phpVersion"           "eq" "${azure_php_version}"    "--php-version"            ""
    # 2.1.5   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' 
    check_azure_app_service_app_value "FTP State"                   "${app_name}" "${resource_group}" "ftpState"             "eq" "${azure_ftp_state}"      "--ftp-state"              ""
    # 2.1.6   Ensure 'HTTP version' is set to '2.0' (if in use)
    check_azure_app_service_app_value "HTTP Version"                "${app_name}" "${resource_group}" "http20Enabled"        "eq" "true"                    "--http20-enabled"         ""
    # 2.1.7   Ensure 'HTTPS Only' is set to 'On'
    check_azure_app_service_app_value "HTTPS Only"                  "${app_name}" "${resource_group}" "httpsOnly"            "eq" "true"                    "httpsOnly"                ""
    # 2.1.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher
    check_azure_app_service_app_value "Minimum Inbound TLS Version" "${app_name}" "${resource_group}" "minTlsVersion"        "eq" "1.2"                     "--min-tls-version"        ""
    # 2.1.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled'
    check_azure_basic_authentication_publishing_credential_value "Basic Authentication Publishing Credentials" "${app_name}" "${resource_group}" "ftp" "Microsoft.Web" "basicPublishingCredentialsPolicies" "properties.allow" "eq" "false" "--auth-settings.publishing-credentials-enabled" ""
    check_azure_basic_authentication_publishing_credential_value "Basic Authentication Publishing Credentials" "${app_name}" "${resource_group}" "scm" "Microsoft.Web" "basicPublishingCredentialsPolicies" "properties.allow" "eq" "false" "--auth-settings.publishing-credentials-enabled" ""
  done
}
