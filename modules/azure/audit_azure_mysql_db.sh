#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_mysql_db
#
# Check Azure Database for MySQL
#
# Azure Database for MySQL
# 5.1 Ensure Azure Database for MySQL uses Customer Managed Keys for Encryption at Rest
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
      # 5.1 Ensure Azure Database for MySQL uses Customer Managed Keys for Encryption at Rest
      check_cosmos_db_value "Customer-Managed Keys" "server" "${mysql_server}" "${resource_group}" "keyVaultKeyUri" "ne" "" "" ""
    done
  fi
  command="az mysql flexible-server list --query \"[].name\" --output tsv"
  command_message "${command}" "check"
  mysql_servers=$( eval "${command}" )
  if [ "${mysql_servers}" = "" ]; then
    verbose_message "No MySQL flexible servers found" "info"
  else
    for mysql_server in ${mysql_servers}; do
      command="az mysql flexible-server show --name ${mysql_server} --query \"resourceGroup\" --output tsv"
      command_message "${command}" "check"
      resource_group=$( eval "${command}" )
      # 5.1 Ensure Azure Database for MySQL uses Customer Managed Keys for Encryption at Rest
      check_cosmos_db_value "Customer-Managed Keys" "flexible-server" "${mysql_server}" "${resource_group}" "keyVaultKeyUri" "ne" "" "" ""
    done
  fi
}
