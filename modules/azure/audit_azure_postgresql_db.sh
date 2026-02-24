#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_postgresql_db
#
# Check Azure Database for PostgreSQL
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
# Refer to Section(s) 6 Page(s) 106-138 Microsoft Azure Database Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_postgresql_db () {
  print_function  "audit_azure_postgresql_db"
  verbose_message "Azure Database for PostgreSQL" "check"
  command="az postgresql server list --query \"[].name\" --output tsv"
  command_message "${command}" "check"
  postgresql_servers=$( eval "${command}" )
  if [ "${postgresql_servers}" = "" ]; then
    verbose_message "No PostgreSQL servers found" "info"
  else
    for postgresql_server in ${postgresql_servers}; do
      command="az postgresql server show --name ${postgresql_server} --query \"resourceGroup\" --output tsv"
      command_message "${command}" "check"
      resource_group=$( eval "${command}" )
      # 6.1 Ensure Azure Database for PostgreSQL uses Customer Managed Keys for Encryption at Rest - TBD
      check_postgresql_db_value "Customer-Managed Keys" "server" "${postgresql_server}" "${resource_group}" "" "keyVaultKeyUri"             "ne" ""         "" ""
      # 6.2 Ensure Azure Database for PostgreSQL uses only Microsoft Entra Authentication - TBD
      # check_postgresql_db_value "Microsoft Entra Authentication" "server" "${postgresql_server}" "${resource_group}" "" "" "" "" "" ""
      # 6.3 Ensure `Public Network Access` is `Disabled` for Azure Database for PostgreSQL - TBD
      check_postgresql_db_value "Public Network Access" "server" "${postgresql_server}" "${resource_group}" "" "publicNetworkAccess"        "eq" "Disabled" "" ""
      # 6.4 Ensure Private Endpoints Are Used for Azure PostgreSQL Databases - TBD
      check_postgresql_db_value "Private Endpoints"     "server" "${postgresql_server}" "${resource_group}" "" "privateEndpointConnections" "ne" ""         "" ""
      # 6.5  Ensure server parameter 'connection_throttle.enable' is set to 'ON' for PostgreSQL server - TBD
      # check_postgresql_db_value "Connection Throttle" "server" "${postgresql_server}" "${resource_group}" "" "connection_throttle.enable" "eq" "ON" "" ""
      # 6.6  Ensure server parameter 'logfiles.retention_days' is greater than 3 days for PostgreSQL server - TBD
      # check_postgresql_db_value "Log Retention" "server" "${postgresql_server}" "${resource_group}" "" "logfiles.retention_days" "gt" "3" "" ""
      # 6.7  Ensure server parameter 'log_checkpoints' is set to 'ON' for PostgreSQL server - TBD
      # check_postgresql_db_value "Log Checkpoints" "server" "${postgresql_server}" "${resource_group}" "" "log_checkpoints" "eq" "ON" "" ""
      # 6.8  Ensure server parameter 'log_disconnections' is set to 'ON' for PostgreSQL servers - TBD
      # check_postgresql_db_value "Log Disconnections" "server" "${postgresql_server}" "${resource_group}" "" "log_disconnections" "eq" "ON" "" ""
      # 6.9  Ensure server parameter 'log_connections' is set to 'ON' for PostgreSQL servers - TBD
      # check_postgresql_db_value "Log Connections" "server" "${postgresql_server}" "${resource_group}" "" "log_connections" "eq" "ON" "" ""
      # 6.10 Ensure server parameter 'require_secure_transport' is set to 'ON' for PostgreSQL server - TBD
      # check_postgresql_db_value "Require Secure Transport" "server" "${postgresql_server}" "${resource_group}" "" "require_secure_transport" "eq" "ON" "" ""
      # 6.11 Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for PostgreSQL server - TBD
      # check_postgresql_db_value "TLS Version" "server" "${postgresql_server}" "${resource_group}" "" "tls_version" "eq" "TLSv1.2" "" ""
    done
  fi
  command="az postgresql flexible-server list --query \"[].name\" --output tsv"
  command_message "${command}" "check"
  postgresql_flexible_servers=$( eval "${command}" )
  if [ "${postgresql_flexible_servers}" = "" ]; then
    verbose_message "No PostgreSQL flexible servers found" "info"
  else
    for postgresql_flexible_server in ${postgresql_flexible_servers}; do
      command="az postgresql flexible-server show --server-name ${postgresql_flexible_server} --query \"resourceGroup\" --output tsv"
      command_message "${command}" "check"
      resource_group=$( eval "${command}" )
      command="az postgresql flexible-server db list --server-name ${postgresql_flexible_server} --resource-group ${resource_group} --query \"[].name\" --output tsv"
      command_message "${command}" "check"
      db_names=$( eval "${command}" )
      for db_name in ${db_names}; do
        # 6.1 Ensure Azure Database for MySQL uses Customer Managed Keys for Encryption at Rest - TBD
        check_postgresql_db_value "Customer-Managed Keys" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "keyVaultKeyUri"             "ne" ""         "" ""
        # 6.2 Ensure Azure Database for MySQL uses only Microsoft Entra Authentication - TBD
        # check_postgresql_db_value "Microsoft Entra Authentication" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "" "" "" "" ""
        # 6.3 Ensure `Public Network Access` is `Disabled` for Azure Database for MySQL - TBD
        check_postgresql_db_value "Public Network Access" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "publicNetworkAccess"        "eq" "Disabled" "" ""
        # 6.4 Ensure Private Endpoints Are Used for Azure MySQL Databases - TBD
        check_postgresql_db_value "Private Endpoints"     "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "privateEndpointConnections" "ne" ""         "" ""
        # 6.5  Ensure server parameter 'connection_throttle.enable' is set to 'ON' for PostgreSQL server - TBD
        # check_postgresql_db_value "Connection Throttle" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "connection_throttle.enable" "eq" "ON" "" ""
        # 6.6  Ensure server parameter 'logfiles.retention_days' is greater than 3 days for PostgreSQL server - TBD
        # check_postgresql_db_value "Log Retention" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "logfiles.retention_days" "gt" "3" "" ""
        # 6.7  Ensure server parameter 'log_checkpoints' is set to 'ON' for PostgreSQL server - TBD
        # check_postgresql_db_value "Log Checkpoints" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "log_checkpoints" "eq" "ON" "" ""
        # 6.8  Ensure server parameter 'log_disconnections' is set to 'ON' for PostgreSQL servers - TBD
        # check_postgresql_db_value "Log Disconnections" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "log_disconnections" "eq" "ON" "" ""
        # 6.9  Ensure server parameter 'log_connections' is set to 'ON' for PostgreSQL servers - TBD
        # check_postgresql_db_value "Log Connections" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "log_connections" "eq" "ON" "" ""
        # 6.10 Ensure server parameter 'require_secure_transport' is set to 'ON' for PostgreSQL server - TBD
        # check_postgresql_db_value "Require Secure Transport" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "require_secure_transport" "eq" "ON" "" ""
        # 6.11 Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for PostgreSQL server - TBD
        # check_postgresql_db_value "TLS Version" "flexible-server" "${postgresql_flexible_server}" "${resource_group}" "${db_name}" "tls_version" "eq" "TLSv1.2" "" ""
      done
    done
  fi
}
