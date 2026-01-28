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
# 8.1.3.2  Ensure that 'Vulnerability assessment for machines' component status is set to 'On'
# 8.1.4.1  Ensure That Microsoft Defender for Containers Is Set To 'On'
# 8.1.5.1  Ensure That Microsoft Defender for Storage Is Set To 'On'
# 8.1.6.1  Ensure That Microsoft Defender for App Services Is Set To 'On'
# 8.1.7.1  Ensure That Microsoft Defender for Azure Cosmos DB Is Set To 'On'
# 8.1.7.2  Ensure That Microsoft Defender for Open-Source Relational Databases Is Set To 'On'
# 8.1.7.3  Ensure That Microsoft Defender for (Managed Instance) Azure SQL Databases Is Set To 'On'
# 8.1.7.4  Ensure That Microsoft Defender for SQL Servers on Machines Is Set To 'On'
# 8.1.8.1  Ensure That Microsoft Defender for Azure Key Vault Is Set To 'On'
# 8.1.9.1  Ensure That Microsoft Defender for Resource Manager Is Set To 'On'
# 8.1.10   Ensure that Microsoft Defender for Cloud is configured to check VM operating systems for updates - TBD
# 8.1.16   Ensure that Microsoft Defender External Attack Surface Monitoring (EASM) is enabled - TBD
#
# Refer to Section(s) 8.1.1- Page(s) 338-472 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_microsoft_defender () {
  print_function  "audit_azure_microsoft_defender"
  verbose_message "Azure Microsoft Defender" "check"
  # 8.1.1.1 Ensure Microsoft Defender CSPM is set to 'On'
  check_azure_microsoft_defender_value "Cloud Security Posture Management (CSPM)"            "CloudPosture"                  "Standard" "On"     ""
  # 8.1.2.1 Ensure Microsoft Defender CWP is set to 'On'
  check_azure_microsoft_defender_value "Cloud Workload Protection (CWP)"                     "Api"                           "Standard" "On"     ""
  # 8.1.3.1 Ensure that Defender for Servers is set to 'On'
  check_azure_microsoft_defender_value "Defender for Servers"                                "VirtualMachines"               "Standard" "On"     ""
  # 8.1.4.1 Ensure That Microsoft Defender for Containers Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for Containers"                             "ContainerRegistry"             "Standard" "On"     ""
  # 8.1.5.1 Ensure That Microsoft Defender for Storage Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for Storage"                                "StorageAccounts"               "Standard" "On"     ""
  # 8.1.6.1 Ensure That Microsoft Defender for App Services Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for App Services"                           "AppServices"                   "Standard" "On"     ""
  # 8.1.7.1 Ensure That Microsoft Defender for Azure Cosmos DB Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for Cosmos DB"                              "CosmosDbs"                     "Standard" "On"     ""
  # 8.1.7.2 Ensure That Microsoft Defender for Open-Source Relational Databases Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for Open-Source Relational Databases"       "OpenSourceRelationalDatabases" "Standard" "On"     ""
  # 8.1.7.3 Ensure That Microsoft Defender for (Managed Instance) Azure SQL Databases Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for (Managed Instance) Azure SQL Databases" "SqlServers"                    "Standard" "On"     ""
  # 8.1.7.4 Ensure That Microsoft Defender for SQL Servers on Machines Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for SQL Servers on Machines"                "SqlServersVirtualMachines"     "Standard" "On"     ""
  # 8.1.8.1 Ensure That Microsoft Defender for Azure Key Vault Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for Azure Key Vault"                        "KeyVaults"                     "Standard" "On"     ""
  # 8.1.9.1 Ensure That Microsoft Defender for Resource Manager Is Set To 'On'
  check_azure_microsoft_defender_value "Defender for Resource Manager"                       "Arm"                           "Standard" "On"     ""
  # 8.1.10  Ensure that Microsoft Defender for Cloud is configured to check VM operating systems for updates - TBD
  # 8.1.16  Ensure that Microsoft Defender External Attack Surface Monitoring (EASM) is enabled - TBD
  check_azure_microsoft_defender_value "Defender for External Attack Surface Monitoring"     ""                              "Standard" "Exists" "Microsoft.Easm/workspaces"
}
