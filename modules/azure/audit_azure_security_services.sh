#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_security_services
#
# Check Azure Security Services
#
# 8.1.1.1  Ensure Microsoft Defender CSPM is set to 'On'
# 8.1.2.1  Ensure Microsoft Defender for APIs is set to 'On'
# 8.1.3.1  Ensure that Defender for Servers is set to 'On'
# 8.1.3.2  Ensure that 'Vulnerability assessment for machines' component status is set to 'On'
# 8.1.3.3  Ensure that 'Endpoint protection' component status is set to 'On'
# 8.1.3.4  Ensure that 'Agentless scanning for machines' component status is set to 'On'
# 8.1.3.5  Ensure that 'File Integrity Monitoring' component status is set to 'On'
# 8.1.4.1  Ensure That Microsoft Defender for Containers Is Set To 'On'
# 8.1.5.1  Ensure That Microsoft Defender for Storage Is Set To 'On'
# 8.1.5.2  Ensure Advanced Threat Protection Alerts for Storage Accounts Are Monitored
# 8.1.6.1  Ensure That Microsoft Defender for App Services Is Set To 'On'
# 8.1.7.1  Ensure That Microsoft Defender for Azure Cosmos DB Is Set To 'On'
# 8.1.7.2  Ensure That Microsoft Defender for Open-Source Relational Databases Is Set To 'On'
# 8.1.7.3  Ensure That Microsoft Defender for (Managed Instance) Azure SQL Databases Is Set To 'On'
# 8.1.7.4  Ensure That Microsoft Defender for SQL Servers on Machines Is Set To 'On'
# 8.1.8.1  Ensure That Microsoft Defender for Key Vault Is Set To 'On'
# 8.1.9.1  Ensure That Microsoft Defender for Resource Manager Is Set To 'On'
# 8.1.10   Ensure that Microsoft Defender for Cloud is configured to check VM operating systems for updates
# 8.1.11   Ensure that Microsoft Cloud Security Benchmark policies are not set to 'Disabled'
# 8.1.12   Ensure That 'All users with the following roles' is set to 'Owner'
# 8.1.13   Ensure 'Additional email addresses' is Configured with a Security Contact Email
# 8.1.14   Ensure that 'Notify about alerts with the following severity (or higher)' is enabled
# 8.1.15   Ensure that 'Notify about attack paths with the following risk level (or higher)' is enabled
# 8.1.16   Ensure that Microsoft Defender External Attack Surface Monitoring (EASM) is enabled
# 8.2.1    Ensure That Microsoft Defender for IoT Hub Is Set To 'On'
# 8.3.1    Ensure that the Expiration Date is set for all Keys in RBAC Key Vaults
# 8.3.2    Ensure that the Expiration Date is set for all Keys in Non-RBAC Key Vaults.
# 8.3.3    Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults
# 8.3.4    Ensure that the Expiration Date is set for all Secrets in Non- RBAC Key Vaults
# 8.3.5    Ensure 'Purge protection' is set to 'Enabled' (Automated)
# 8.3.6    Ensure that Role Based Access Control for Azure Key Vault is enabled
# 8.3.7    Ensure Public Network Access is Disabled
# 8.3.8    Ensure Private Endpoints are used to access Azure Key Vault
# 8.3.9    Ensure automatic key rotation is enabled within Azure Key Vault
# 8.3.10   Ensure that Azure Key Vault Managed HSM is used when required
# 8.3.11   Ensure certificate 'Validity Period (in months)' is less than or equal to '12'
# 8.4.1    Ensure an Azure Bastion Host Exists
# 8.5      Ensure Azure DDoS Network Protection is enabled on virtual networks
# Refer to Section(s) 8.1-5 Page(s) 338-472 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_security_services () {
  print_function  "audit_azure_security_services"
  verbose_message "Azure Security Services" "check"
}
