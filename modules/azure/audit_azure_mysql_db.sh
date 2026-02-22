#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_mysql_db
#
# Check Azure Database for MySQL
#
# Azure Database for MySQL
# 5.1 Ensure Azure Database for MySQL uses Customer Managed Keys for Encryption at Rest - TBD
# 5.2 Ensure Azure Database for MySQL uses only Microsoft Entra Authentication - TBD
# 5.3 Ensure `Public Network Access` is `Disabled` for Azure Database for MySQL - TBD
# 5.4 Ensure Private Endpoints Are Used for Azure MySQL Databases - TBD
# 5.5 Ensure server parameter 'audit_log_enabled' is set to 'ON' for MySQL flexible server - TBD
# 5.6 Ensure server parameter 'audit_log_events' has 'CONNECTION' set for MySQL flexible server - TBD
# 5.7 Ensure server parameter 'error_server_log_file' is Enabled for MySQL Database Server - TBD
# 5.8 Ensure server parameter 'require_secure_transport' is set to 'ON' for MySQL Server - TBD
# 5.9 Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for MySQL flexible server - TBD
#
# Refer to Section(s) 5- Page(s) 84- Microsoft Azure Database Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_mysql_db () {
  print_function  "audit_azure_mysql_db"
  verbose_message "Azure Database for MySQL" "check"
  command="az mysql server list --query \"[].name\" --output tsv"
  command_message "${command}" "check"
  mysql_servers=$( eval "${command}" )
  if [ "${mysql_servers}" = "" ]; then
    verbose_message "No MySQL servers found" "info"
  else
    for mysql_server in ${mysql_servers}; do
      command="az mysql server show --name ${mysql_server} --query \"resourceGroup\" --output tsv"
      command_message "${command}" "check"
      resource_group=$( eval "${command}" )
      # 5.1 Ensure Azure Database for MySQL uses Customer Managed Keys for Encryption at Rest - TBD
      check_mysql_db_value "Customer-Managed Keys" "server" "${mysql_server}" "${resource_group}" "" "keyVaultKeyUri"             "ne" ""         "" ""
      # 5.2 Ensure Azure Database for MySQL uses only Microsoft Entra Authentication - TBD
      # check_mysql_db_value "Microsoft Entra Authentication" "server" "${mysql_server}" "${resource_group}" "" "" "" "" "" ""
      # 5.3 Ensure `Public Network Access` is `Disabled` for Azure Database for MySQL - TBD
      check_mysql_db_value "Public Network Access" "server" "${mysql_server}" "${resource_group}" "" "publicNetworkAccess"        "eq" "Disabled" "" ""
      # 5.4 Ensure Private Endpoints Are Used for Azure MySQL Databases - TBD
      check_mysql_db_value "Private Endpoints"     "server" "${mysql_server}" "${resource_group}" "" "privateEndpointConnections" "ne" ""         "" ""
      # 5.5 Ensure server parameter 'audit_log_enabled' is set to 'ON' for MySQL server - TBD
      # check_mysql_db_value "Audit Log"             "server" "${mysql_server}" "${resource_group}" "" "audit_log_enabled"          "eq" "ON"         "" ""
      # 5.6 Ensure server parameter 'audit_log_events' has 'CONNECTION' set for MySQL server - TBD
      # check_mysql_db_value "Audit Log Events"       "server" "${mysql_server}" "${resource_group}" "" "audit_log_events"           "eq" "CONNECTION"   "" ""
      # 5.7 Ensure server parameter 'error_server_log_file' is Enabled for MySQL Database Server - TBD
      # check_mysql_db_value "Error Server Log File" "server" "${mysql_server}" "${resource_group}" "" "error_server_log_file"        "eq" "Enabled"    "" ""
      # 5.8 Ensure server parameter 'require_secure_transport' is set to 'ON' for MySQL Server - TBD
      # check_mysql_db_value "Require Secure Transport" "server" "${mysql_server}" "${resource_group}" "" "require_secure_transport" "eq" "ON"         "" ""
      # 5.9 Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for MySQL flexible server - TBD
      # check_mysql_db_value "TLS Version" "server" "${mysql_server}" "${resource_group}" "" "tls_version" "eq" "TLSv1.2" "" ""
    done
  fi
  command="az mysql flexible-server list --query \"[].name\" --output tsv"
  command_message "${command}" "check"
  mysql_servers=$( eval "${command}" )
  if [ "${mysql_servers}" = "" ]; then
    verbose_message "No MySQL flexible servers found" "info"
  else
    for mysql_server in ${mysql_servers}; do
      command="az mysql flexible-server show --server-name ${mysql_server} --query \"resourceGroup\" --output tsv"
      command_message "${command}" "check"
      resource_group=$( eval "${command}" )
      command="az mysql flexible-server db list --server-name ${mysql_server} --resource-group ${resource_group} --query \"[].name\" --output tsv"
      command_message "${command}" "check"
      db_names=$( eval "${command}" )
      for db_name in ${db_names}; do
        # 5.1 Ensure Azure Database for MySQL uses Customer Managed Keys for Encryption at Rest - TBD
        check_mysql_db_value "Customer-Managed Keys" "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "keyVaultKeyUri"             "ne" ""         "" ""
        # 5.2 Ensure Azure Database for MySQL uses only Microsoft Entra Authentication - TBD
        # check_mysql_db_value "Microsoft Entra Authentication" "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "" "" "" "" ""
        # 5.3 Ensure `Public Network Access` is `Disabled` for Azure Database for MySQL - TBD
        check_mysql_db_value "Public Network Access" "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "publicNetworkAccess"        "eq" "Disabled" "" ""
        # 5.4 Ensure Private Endpoints Are Used for Azure MySQL Databases - TBD
        check_mysql_db_value "Private Endpoints"     "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "privateEndpointConnections" "ne" ""         "" ""
        # 5.5 Ensure server parameter 'audit_log_enabled' is set to 'ON' for MySQL flexible server - TBD
        # check_mysql_db_value "Audit Log"             "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "audit_log_enabled"          "eq" "ON"       "" ""
        # 5.6 Ensure server parameter 'audit_log_events' has 'CONNECTION' set for MySQL flexible server - TBD
        # check_mysql_db_value "Audit Log Events"      "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "audit_log_events"           "eq" "CONNECTION"   "" ""
        # 5.7 Ensure server parameter 'error_server_log_file' is Enabled for MySQL Database Server - TBD
        # check_mysql_db_value "Error Server Log File" "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "error_server_log_file"        "eq" "Enabled"    "" ""
        # 5.8 Ensure server parameter 'require_secure_transport' is set to 'ON' for MySQL Server - TBD
        # check_mysql_db_value "Require Secure Transport" "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "require_secure_transport" "eq" "ON"         "" ""
        # 5.9 Ensure server parameter 'tls_version' is set to 'TLSv1.2' (or higher) for MySQL flexible server - TBD
        # check_mysql_db_value "TLS Version" "flexible-server" "${mysql_server}" "${resource_group}" "${db_name}" "tls_version" "eq" "TLSv1.2" "" ""
      done
    done
  fi
}
