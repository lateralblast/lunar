#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_ec
#
# Check AWS ElastiCache
#
# Refer to https://www.cloudconformity.com/conformity-rules/ElastiCache/elasticache-multi-az.html
#.

audit_aws_ec () {
  print_function  "audit_aws_ec"
  verbose_message "ElastiCache" "check"
  command="aws elasticache describe-replication-groups --region \"${aws_region}\" --query 'ReplicationGroups[].ReplicationGroupId' --output text"
  command_message "${command}"
  caches=$( eval "${command}" )
  for cache in ${caches}; do 
    command="aws elasticache describe-replication-groups --region \"${aws_region}\" --replication-group-id \"${cache}\" --query 'ReplicationGroups[].AutomaticFailover' | grep enabled"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure   "ElastiCache \"${cache}\" is Multi-AZ enabled"
    else
      increment_insecure "ElastiCache \"${cache}\" is not Multi-AZ enabled"
      lockdown_command="aws elasticache modify-replication-group --region ${aws_region} --replication-group-id ${cache} --automatic-failover-enabled --apply-immediately"
      lockdown_message="ElastiCache \"${cache}\" Multi-AZ to enabled"
      execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
    fi
  done
}

