#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_database_services
#
# Check Azure Database Services
#
# Refer to Section(s) 4 Page(s) 69 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# Redis
# 2.1  Ensure 'Microsoft Entra Authentication' is 'Enabled' - TBD
# 2.2  Ensure that 'Allow access only via SSL' is set to 'Yes'
# 2.3  Ensure that 'Minimum TLS version' is set to '1.2'
# 2.4  Ensure that 'Access Policies' are Implemented and Reviewed Periodically - TBD
# 2.5  Ensure that 'System Assigned Managed Identity' is set to 'On' - TBD
# 2.6  Ensure that 'Public Network Access' is 'Disabled'
# 2.7  Ensure Azure Cache for Redis is Using a Private Link
# 2.8  Ensure that Azure Cache for Redis is Using Customer-Managed Keys
# 2.9  Ensure 'Access Keys Authentication' is set to 'Disabled'
# 2.10 Ensure 'Update Channel' is set to 'Stable' 
#
# Cosmos DB
# 3.1  Ensure That 'Firewalls & Networks' Is Limited to Use Selected Networks Instead of All Networks
# 3.2  Ensure that Cosmos DB uses Private Endpoints where possible
# 3.3  Ensure that 'disableLocalAuth' is set to 'true'
# 3.4  Ensure `Public Network Access` is `Disabled`
# 3.5  Ensure critical data is encrypted with customer-managed keys (CMK)
# 3.6  Ensure the firewall does not allow all network traffic
# 3.7  Ensure that Cosmos DB Logging is Enabled
# 3.8  Ensure Data Factory is encrypted using Customer Managed Keys
#
# Data Factory
# 4.1  Ensure Data Factory is encrypted using Customer Managed Keys
# 4.2  Ensure Data Factory is using Managed Identities - TBD
# 4.3  Ensure that Data Factory is using Azure Key Vault to store Credentials and Secrets - TBD
# 4.4  Ensure that Data Factory is using RBAC to manage privilege assignment - TBD
# 5.2  Ensure Azure Database for MySQL uses only Microsoft Entra Authentication - TBD
#
# Azure Database for MySQL
# 5.1  Ensure Azure Database for MySQL uses Customer Managed Keys for Encryption at Rest - TBD
# 5.2  Ensure Azure Database for MySQL uses only Microsoft Entra Authentication - TBD
# 5.3  Ensure `Public Network Access` is `Disabled` for Azure Database for MySQL - TBD
# 5.4  Ensure Private Endpoints Are Used for Azure MySQL Databases - TBD
# 5.5  Ensure server parameter 'audit_log_enabled' is set to 'ON' for MySQL flexible server - TBD
# 5.6  Ensure server parameter 'audit_log_events' has 'CONNECTION' set for MySQL flexible server - TBD
# 5.7  Ensure server parameter 'error_server_log_file' is Enabled for MySQL Database Server - TBD
# 5.8  Ensure server parameter 'require_secure_transport' is set to 'ON' for MySQL Server - TBD
# 5.9  Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for MySQL flexible server - TBD
#
# Azure Database for PostgreSQL
# 6.1  Ensure Azure Database for PostgreSQL uses Customer Managed Keys for Encryption at Rest - TBD
# 6.2  Ensure Azure Database for PostgreSQL uses only Microsoft Entra Authentication - TBD
# 6.3  Ensure `Public Network Access` is `Disabled` for Azure Database for PostgreSQL - TBD
# 6.4  Ensure Private Endpoints Are Used for Azure PostgreSQL Databases - TBD
# 6.5  Ensure server parameter 'connection_throttle.enable' is set to 'ON' for PostgreSQL server - TBD
# 6.6  Ensure server parameter 'logfiles.retention_days' is greater than 3 days for PostgreSQL server - TBD
# 6.7  Ensure server parameter 'log_checkpoints' is set to 'ON' for PostgreSQL server - TBD
# 6.8  Ensure server parameter 'log_disconnections' is set to 'ON' for PostgreSQL servers - TBD
# 6.9  Ensure server parameter 'log_connections' is set to 'ON' for PostgreSQL servers - TBD
# 6.10 Ensure server parameter 'require_secure_transport' is set to 'ON' for PostgreSQL server - TBD
# 6.11 Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for PostgreSQL server - TBD
#
# Azure SQL Database
# 9.1 Ensure that 'Auditing' is set to 'On' - TBD
# 9.2 Ensure that 'Public Network Access' is set to 'Disable' - TBD
# 9.3 Ensure no Azure SQL Database firewall rule is overly permissive - TBD
# 9.4 Ensure SQL server's Transparent Data Encryption (TDE) protector is encrypted with Customer-managed key - TBD
# 9.5 Ensure that Microsoft Entra authentication is Configured for SQL Servers - TBD
# 9.6 Ensure that 'Data encryption' is set to 'On' on a SQL Database - TBD
# 9.7 Ensure that 'Auditing' Retention is 'greater than 90 days' - TBD
# 9.8 Ensure 'Minimum TLS Version' is set to 'TLS 1.2' or higher - TBD
#
# Refer to Section(s) 2- Page(s) 11- Microsoft Azure Database Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_database_services () {
  print_function  "audit_azure_database_services"
  verbose_message "Azure Database Services" "check"
  audit_azure_redis_cache
  audit_azure_cosmos_db
  audit_azure_data_factory
  audit_azure_mysql_db
  audit_azure_postgresql_db
  audit_azure_sql_db
}
