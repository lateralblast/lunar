#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_microsoft_defender
#
# Check Azure Microsoft Defender
#
# 8.1.1.1  Ensure Microsoft Defender CSPM is set to 'On'
# 8.1.2.1  Ensure Microsoft Defender CWP is set to 'On'
# 8.1.3.1  Ensure that Defender for Servers is set to 'On'
#
# Refer to Section(s) 8.1.1- Page(s) 338-472 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_microsoft_defender () {
  print_function  "audit_azure_microsoft_defender"
  verbose_message "Azure Microsoft Defender" "check"
  # 8.1.1.1  Ensure Microsoft Defender CSPM is set to 'On'
  check_azure_microsoft_defender_value "Cloud Security Posture Management (CSPM)" "CloudPosture"    "Standard" "Om"
  # 8.1.2.1  Ensure Microsoft Defender CWP is set to 'On'
  check_azure_microsoft_defender_value "Cloud Workload Protection (CWP)"          "Api"             "Standard" "On"
  # 8.1.3.1 Ensure that Defender for Servers is set to 'On'
  check_azure_microsoft_defender_value "Defender for Servers"                     "VirtualMachines" "Standard" "On"
}

