#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_security_contacts
#
# Check Azure Security Contacts
#
# 8.1.12 Ensure That 'All users with the following roles' is set to 'Owner'
# 8.1.13 Ensure 'Additional email addresses' is Configured with a Security Contact Email
# 8.1.14 Ensure that 'Notify about alerts with the following severity (or higher)' is enabled
#
# Refer to Section(s) 8.1.12 Page(s) 406-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# Refer to https://learn.microsoft.com/en-us/cli/azure/security/contact?view=azure-cli-latest
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_security_contacts () {
  print_function  "audit_azure_security_contacts"
  verbose_message "Azure Security Contacts" "check"
  contact_names=$( az security contact list --query "[].name" --output tsv 2>/dev/null )
  if [ -z "$contact_names" ]; then
    increment_insecure "No Azure Security Contacts found"
    verbose_message    "az security contact create --name <contact-name> --email <email-address> --notifications-by-role '{"state":"On","roles":["Owner"]}' --alert-notifications '{"state":"On","minimalSeverity":"Low"}'" "fix"
  else
    for contact_name in $contact_names; do
      check_azure_security_contact_value "${contact_name}" "email"                              "ne" ""
      check_azure_security_contact_value "${contact_name}" "alertNotifications.state"           "eq" "On"
      check_azure_security_contact_value "${contact_name}" "notificationsByRole.roles"          "eq" "Owner"
      check_azure_security_contact_value "${contact_name}" "alertNotifications.minimalSeverity" "eq" "Low"
    done
  fi
}
