#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_identity_services
#
# Check Azure Identity Services
#
# Refer to Section(s) 5.1-28 Page(s) 70-190 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_identity_services () {
  print_function  "audit_azure_identity_services"
  verbose_message "Azure Identity Services" "check"
  # 5.1.1 Ensure that 'security defaults' is enabled in Microsoft Entra ID - TBD
  # 5.1.2 Ensure that 'multifactor authentication' is 'enabled' for all users - TBD
  # 5.1.3 Ensure that 'Allow users to remember multifactor authentication on devices they trust' is disabled - TBD
  # 5.2.1 Ensure that 'trusted locations' are defined - TBD
  # 5.2.2 Ensure that an exclusionary geographic Conditional Access policy is considered - TBD
  # 5.2.3 Ensure that an exclusionary device code flow policy is considered - TBD
  # 5.2.4 Ensure that a multifactor authentication policy exists for all users - TBD
  # 5.2.5 Ensure that multifactor authentication is required for risky sign-ins - TBD
  # 5.2.6 Ensure that multifactor authentication is required for Windows Azure Service Management API - TBD
  # 5.2.7 Ensure that multifactor authentication is required to access Microsoft Admin Portals - TBD
  # 5.2.8 Ensure a Token Protection Conditional Access policy is considered - TBD
  # 5.3.1 Ensure that Azure admin accounts are not used for daily operations - TBD
  # 5.3.2 Ensure that guest users are reviewed on a regular basis
  audit_azure_guest_users
}
