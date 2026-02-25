#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_compute_services
#
# Check Azure Compute Services
#
# Refer to Section(s) 3 Page(s) 63-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to CIS Microsoft Azure Compute Services Benchmark
#
# App Service Apps
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
# 2.2.12  Ensure 'App Service authentication' is set to 'Enabled' - TBD
# 2.2.13  Ensure managed identities are configured - TBD
# 2.2.14  Ensure deployment slot is integrated with a virtual network - TBD
# 2.2.15  Ensure configuration is routed through the virtual network integration - TBD
# 2.2.16  Ensure all traffic is routed through the virtual network - TBD
# 2.2.17  Ensure cross-origin resource sharing does not allow all origins - TBD
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
# Functions Deployment Slots
# 2.4.1 Ensure 'Java version' is currently supported (if in use) - TBD
# 2.4.2 Ensure 'Python version' is currently supported (if in use) - TBD
# 2.4.3 Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
# 2.4.4 Ensure 'FTP state' is set to 'FTPS only' or 'Disabled' - TBD
# 2.4.5 Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
# 2.4.6 Ensure 'HTTPS Only' is set to 'On' - TBD
# 2.4.7 Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
# 2.4.8 Ensure end-to-end TLS encryption is enabled - TBD
# 2.4.9 Ensure 'Remote debugging' is set to 'Off' - TBD
# 2.4.10 Ensure incoming client certificates are enabled and required (if in use) - TBD
# 2.4.11 Ensure managed identities are configured - TBD
# 2.4.12 Ensure public network access is disabled - TBD
# 2.4.13 Ensure deployment slot is integrated with a virtual network - TBD
# 2.4.14 Ensure configuration is routed through the virtual network integration - TBD
# 2.4.15 Ensure all traffic is routed through the virtual network - TBD
# 2.4.16 Ensure cross-origin resource sharing does not allow all origins - TBD
#
# Refer to Section(s) 2 Page(s) 22- CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_compute_services () {
  print_function  "audit_azure_compute_services"
  verbose_message "Azure Compute Services" "check"
  audit_azure_app_service_apps
  audit_azure_app_service_deployment_slots
  audit_azure_function_apps
  audit_azure_function_apps_deployment_slots
}
