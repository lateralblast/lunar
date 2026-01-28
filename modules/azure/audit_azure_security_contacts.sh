#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_security_contacts
#
# Check Azure Security Contacts
#
# 8.1.12 Ensure That 'All users with the following roles' is set to 'Owner'
# Refer to Section(s) 8.1.12 Page(s) 406-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_security_contacts () {
  print_function  "audit_azure_security_contacts"
  verbose_message "Azure Security Contacts" "check"
  contact_names=$( az security contact list --query "[].name" --output tsv 2>/dev/null )
  if [ -z "$contact_names" ]; then
    increment_insecure "No Azure Security Contacts found"
  else
    for contact_name in $contact_names; do
      check_azure_security_contact_value "${contact_name}" "email"                     "ne" ""
      check_azure_security_contact_value "${contact_name}" "alertNotifications.state"  "eq" "On"
      check_azure_security_contact_value "${contact_name}" "notificationsByRole.roles" "eq" "Owner"
    done
  fi
}
