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
#
# Refer to Section(s) 2- Page(s) 11- Microsoft Azure Database Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_database_services () {
  print_function  "audit_azure_database_services"
  verbose_message "Azure Database Services" "check"
  audit_azure_redis_cache
  audit_azure_cosmos_db
}
