#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_networking_services
#
# Check Azure Networking Services
#
# 7.1  Ensure that RDP access from the Internet is evaluated and restricted
# 7.2  Ensure that SSH access from the Internet is evaluated and restricted
# 7.3  Ensure that UDP access from the Internet is evaluated and restricted
# 7.4  Ensure that HTTP(S) access from the Internet is evaluated and restricted
# 7.5  Ensure that network security group flow log retention days is set to greater than or equal to 90
# 7.6  Ensure that Network Watcher is 'Enabled' for Azure Regions that are in use
# 7.7  Ensure that Public IP addresses are Evaluated on a Periodic Basis (Manual)
# 7.8  Ensure that virtual network flow log retention days is set to greater than or equal to 90
# 7.9  Ensure 'Authentication type' is set to 'Azure Active Directory' only for Azure VPN Gateway point-to-site configuration
# 7.10 Ensure Azure Web Application Firewall (WAF) is enabled on Azure Application Gateway
# 7.11 Ensure subnets are associated with network security groups
# 7.12 Ensure the SSL policy's 'Min protocol version' is set to 'TLSv1_2' or higher on Azure Application Gateway
# 7.13 Ensure 'HTTP2' is set to 'Enabled' on Azure Application Gateway
# 7.14 Ensure request body inspection is enabled in Azure Web Application Firewall policy on Azure Application Gateway
# 7.15 Ensure bot protection is enabled in Azure Web Application Firewall policy on Azure Application Gateway
# 7.16 Ensure Azure Network Security Perimeter is used to secure Azure platform-as-a-service resources
# Refer to Section(s) 7.1-16 Page(s) 287-337 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_networking_services () {
  print_function  "audit_azure_networking_services"
  verbose_message "Azure Networking Services" "check"
}
