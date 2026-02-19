#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_database_services
#
# Check Azure Database Services
#
# Refer to Section(s) 4 Page(s) 69 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to CIS Microsoft Azure Database Services Benchmark
#
# 2.2 Ensure that 'Allow access only via SSL' is set to 'Yes'
# 2.3 Ensure that 'Minimum TLS version' is set to TLS v1.2 (or higher)
# 2.6 Ensure that 'Public Network Access' is 'Disabled'
# 2.7 Ensure Azure Cache for Redis is Using a Private Link
#
# Refer to Section(s) 2 Page(s) 11-12 Microsoft Azure Database Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_redis_cache () {
  print_function  "audit_azure_redis_cache"
  verbose_message "Azure Redis Cache" "check"
  command="az redis list --query \"[].name\" --output tsv"
  command_message "${command}"
  redis_names=$( eval "${command}" )
  if [ -z "${redis_names}" ]; then
    verbose_message "No Redis instances found" "info"
    return
  fi
  for redis_name in ${redis_names}; do
    command="az redis show --name \"${redis_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    check_redis_cache_value "Allow access only via SSL" "${redis_name}" "${resource_group}" "sslEnabled"                            "eq" "true"     "enableSsl"
    check_redis_cache_value "Minimum TLS version"       "${redis_name}" "${resource_group}" "minimumTlsVersion"                     "eq" "1.2"      "--minimum-tls-version"
    check_redis_cache_value "Public Network Access"     "${redis_name}" "${resource_group}" "publicNetworkAccess"                   "eq" "disabled" "--public-network-access"
    check_redis_cache_value "Private Link"              "${redis_name}" "${resource_group}" "properties.privateEndpointConnections" "eq" "Approved" "privateEndpointConnections[0].privateLinkServiceConnectionState.status"
  done
}
