#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_sql_db
#
# Check Azure SQL Database
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
# Refer to Section(s) 9 Page(s) 141-170 Microsoft Azure Database Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_sql_db () {
  print_function  "audit_azure_sql_db"
  verbose_message "Azure SQL Database" "check"
  command="az sql server list --query \"[].name\" --output tsv"
  command_message "${command}" "check"
  sql_servers=$( eval "${command}" )
  if [ "${sql_servers}" = "" ]; then
    verbose_message "No SQL servers found" "info"
  else
    for sql_server in ${sql_servers}; do
      command="az sql server show --name ${sql_server} --query \"resourceGroup\" --output tsv"
      command_message "${command}" "check"
      resource_group=$( eval "${command}" )
      # 9.1 Ensure that 'Auditing' is set to 'On' - TBD
      check_sql_db_value "Auditing" "server" "${sql_server}" "${resource_group}" "" "keyVaultKeyUri"             "ne" ""         "" ""
      # 9.2 Ensure that 'Public Network Access' is set to 'Disable' - TBD
      # check_mysql_db_value "Microsoft Entra Authentication" "server" "${mysql_server}" "${resource_group}" "" "" "" "" "" ""
      # 9.3 Ensure no Azure SQL Database firewall rule is overly permissive - TBD
      check_sql_db_value "Public Network Access" "server" "${sql_server}" "${resource_group}" "" "publicNetworkAccess"        "eq" "Disabled" "" ""
      # 9.4 Ensure SQL server's Transparent Data Encryption (TDE) protector is encrypted with Customer-managed key - TBD
      check_sql_db_value "Private Endpoints"     "server" "${sql_server}" "${resource_group}" "" "privateEndpointConnections" "ne" ""         "" ""
      # 9.5 Ensure that Microsoft Entra authentication is Configured for SQL Servers - TBD
      # check_sql_db_value "Audit Log"             "server" "${sql_server}" "${resource_group}" "" "audit_log_enabled"          "eq" "ON"         "" ""
      # 9.6 Ensure that 'Data encryption' is set to 'On' on a SQL Database - TBD
      # check_sql_db_value "Audit Log Events"       "server" "${sql_server}" "${resource_group}" "" "audit_log_events"           "eq" "CONNECTION"   "" ""
      # 9.7 Ensure that 'Auditing' Retention is 'greater than 90 days' - TBD
      # check_sql_db_value "Error Server Log File" "server" "${sql_server}" "${resource_group}" "" "error_server_log_file"        "eq" "Enabled"    "" ""
      # 9.8 Ensure 'Minimum TLS Version' is set to 'TLS 1.2' or higher - TBD
      # check_sql_db_value "Require Secure Transport" "server" "${sql_server}" "${resource_group}" "" "require_secure_transport" "eq" "ON"         "" ""
    done
  fi
}
