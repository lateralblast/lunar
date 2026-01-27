#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_identity_services
#
# Check Azure Identity Services
#
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
# 5.3.3 Ensure that use of the 'User Access Administrator' role is restricted
# 5.3.4 Ensure that all 'privileged' role assignments are periodically reviewed - TBD
# 5.3.5 Ensure disabled user accounts do not have read, write, or owner permissions - TBD
# 5.3.6 Ensure 'Tenant Creator' role assignments are periodically reviewed - TBD
# 5.3.7 Ensure all non-privileged role assignments are periodically reviewed - TBD
# 5.4   Ensure that 'Restrict non-admin users from creating tenants' is set to 'Yes' - TBD
# 5.5   Ensure that 'Number of methods required to reset' is set to '2' - TBD
# 5.6   Ensure that account 'Lockout threshold' is less than or equal to '10' - TBD
# 5.7   Ensure that account 'Lockout duration in seconds' is greater than or equal to '60' - TBD
# 5.8   Ensure that a 'Custom banned password list' is set to 'Enforce' - TBD
# 5.9   Ensure that 'Number of days before users are asked to re-confirm their authentication information' is not set to '0' - TBD
# 5.10  Ensure that 'Notify users on password resets?' is set to 'Yes' - TBD
# 5.11  Ensure that 'Notify all admins when other admins reset their password?' is set to 'Yes' - TBD
# 5.12  Ensure that 'User consent for applications' is set to 'Do not allow user consent'
# 5.13  Ensure that 'User consent for applications' is set to 'Allow user consent for apps from verified publishers, for selected permissions' - TBD
# 5.14  Ensure that 'Users can register applications' is set to 'No' - TBD
# 5.15  Ensure that 'Guest users access restrictions' is set to 'Guest user access is restricted to properties and memberships of their own directory objects' - TBD
# 5.16  Ensure that 'Guest invite restrictions' is set to 'Only users assigned to specific admin roles [...]' or 'No one [..]' - TBD
# 5.18  Ensure that 'Restrict user ability to access groups features in My Groups' is set to 'Yes' - TBD
# 5.19  Ensure that 'Users can create security groups in Azure portals, API or PowerShell' is set to 'No' - TBD
# 5.20  Ensure that 'Owners can manage group membership requests in My Groups' is set to 'No' - TBD
# 5.21  Ensure that 'Users can create Microsoft 365 groups in Azure portals, API or PowerShell' is set to 'No' - TBD
# 5.22  Ensure that 'Require Multifactor Authentication to register or join devices with Microsoft Entra' is set to 'Yes' - TBD
# 5.23  Ensure that no custom subscription administrator roles exist
# 5.24  Ensure that a custom role is assigned permissions for administering resource locks - TBD
# 5.25  Ensure that 'Subscription leaving Microsoft Entra tenant' and 'Subscription entering Microsoft Entra tenant' is set to 'Permit no one' - TBD
# 5.26  Ensure fewer than 5 users have global administrator assignment - TBD
# 5.27  Ensure there are between 2 and 3 subscription owners
# 5.28  Ensure passwordless authentication methods are considered - TBD
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
  # 5.3.3 Ensure that use of the 'User Access Administrator' role is restricted
  audit_azure_user_access_admin_role
  # 5.3.4 Ensure that all 'privileged' role assignments are periodically reviewed - TBD
  # 5.3.5 Ensure disabled user accounts do not have read, write, or owner permissions - TBD
  # 5.3.6 Ensure 'Tenant Creator' role assignments are periodically reviewed - TBD
  # 5.3.7 Ensure all non-privileged role assignments are periodically reviewed - TBD
  # 5.4   Ensure that 'Restrict non-admin users from creating tenants' is set to 'Yes' - TBD
  # 5.5   Ensure that 'Number of methods required to reset' is set to '2' - TBD
  # 5.6   Ensure that account 'Lockout threshold' is less than or equal to '10' - TBD
  # 5.7   Ensure that account 'Lockout duration in seconds' is greater than or equal to '60' - TBD
  # 5.8   Ensure that a 'Custom banned password list' is set to 'Enforce' - TBD
  # 5.9   Ensure that 'Number of days before users are asked to re-confirm their authentication information' is not set to '0' - TBD
  # 5.10  Ensure that 'Notify users on password resets?' is set to 'Yes' - TBD
  # 5.11  Ensure that 'Notify all admins when other admins reset their password?' is set to 'Yes' - TBD
  # 5.12  Ensure that 'User consent for applications' is set to 'Do not allow user consent'
  # 5.13  Ensure that 'User consent for applications' is set to 'Allow user consent for apps from verified publishers, for selected permissions' - TBD
  # 5.14  Ensure that 'Users can register applications' is set to 'No' - TBD
  # 5.15  Ensure that 'Guest users access restrictions' is set to 'Guest user access is restricted to properties and memberships of their own directory objects' - TBD
  # 5.16  Ensure that 'Guest invite restrictions' is set to 'Only users assigned to specific admin roles [...]' or 'No one [..]' - TBD
  # 5.18  Ensure that 'Restrict user ability to access groups features in My Groups' is set to 'Yes' - TBD
  # 5.19  Ensure that 'Users can create security groups in Azure portals, API or PowerShell' is set to 'No' - TBD
  # 5.20  Ensure that 'Owners can manage group membership requests in My Groups' is set to 'No' - TBD
  # 5.21  Ensure that 'Users can create Microsoft 365 groups in Azure portals, API or PowerShell' is set to 'No' - TBD
  # 5.22  Ensure that 'Require Multifactor Authentication to register or join devices with Microsoft Entra' is set to 'Yes' - TBD
  # 5.23  Ensure that no custom subscription administrator roles exist
  audit_azure_custom_subscription_admin_roles
  # 5.24  Ensure that a custom role is assigned permissions for administering resource locks - TBD
  # 5.25  Ensure that 'Subscription leaving Microsoft Entra tenant' and 'Subscription entering Microsoft Entra tenant' is set to 'Permit no one' - TBD
  # 5.26  Ensure fewer than 5 users have global administrator assignment - TBD
  # 5.27  Ensure there are between 2 and 3 subscription owners
  audit_azure_subscription_owners
  # 5.28  Ensure passwordless authentication methods are considered - TBD
}
