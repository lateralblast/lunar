#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_rec_ec
#
# Check ElastiCache Recommendation
#
# Refer to https://www.cloudconformity.com/conformity-rules/ElastiCache/reserved-cache-nodes-expiration.html
#.

audit_aws_rec_ec () {
  print_function  "audit_aws_rec_ec"
  verbose_message "ElastiCache Recommendation" "check"
  # Ensure that your AWS ElastiCache Reserved Instances (RIs) are renewed before expiration
  command="aws elasticache describe-reserved-cache-nodes --region \"${aws_region}\" --query 'ReservedCacheNodes[].ReservedCacheNodeId' --output text"
  command_message "${command}"
  caches=$( eval "${command}" )
  for cache in ${caches}; do
    command="aws elasticache describe-reserved-cache-nodes --region \"${aws_region}\" --reserved-cache-node-id \"${cache}\" --query 'ReservedDBInstances[].ReservedCacheNodes' --output text | cut -f1 -d."
    command_message "${command}"
    start_date=$( eval "${command}" )
    command="aws elasticache describe-reserved-cache-nodes --region \"${aws_region}\" --reserved-cache-node-id \"${cache}\" --query 'ReservedDBInstances[].Duration' --output text"
    command_message "${command}"
    dur_secs=$( eval "${command}" )
    curr_secs=$( date "+%s" )
    if [ "${os_name}" = "Linux" ]; then
      command="date -d \"${start_date}\" \"+%s\""
      command_message "${command}"
      start_secs=$( eval "${command}" )
    else
      command="date -j -f \"%Y-%m-%dT%H:%M:%SS\" \"${start_date}\" \"+%s\""
      command_message "${command}"
      start_secs=$( eval "${command}" )
    fi
    command="echo \"(${start_secs} + ${dur_secs})\" | bc"
    command_message "${command}"
    exp_secs=$( eval "${command}" )
    command="echo \"(7 * 84600)\" |bc"
    command_message "${command}"
    test_secs=$( eval "${command}" )
    command="echo \"(${exp_secs} - ${curr_secs})\" | bc"
    command_message "${command}"
    left_secs=$( eval "${command}" )
    if [ "${left_secs}" -lt "${test_secs}" ]; then
      increment_secure   "Reserved ElastiCache instance \"${cache}\" has more than 7 days remaining"
    else
      increment_insecure "Reserved ElastiCache instance \"${cache}\" has less than 7 days remaining"
    fi
  done
}