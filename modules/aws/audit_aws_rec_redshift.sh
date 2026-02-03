#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_rec_redshift
#
# Check AWS Redshift recommendations
#
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/reserved-nodes-expiration.html
#.

audit_aws_rec_redshift () {
  print_function  "audit_aws_rec_redshift"
  verbose_message "Redshift Recommendations" "check"
  command="aws redshift describe-reserved-nodes --region \"${aws_region}\" --query 'ReservedNodes[].ReservedNodeId' --output text"
  command_message "${command}"
  dbs=$( eval "${command}" )
  for db in ${dbs}; do
    command="aws redshift describe-reserved-nodes --region \"${aws_region}\" --reserved-node-id \"${dir_name}\" --query 'ReservedNodes[].StartTime' --output text | cut -f1 -d. "
    command_message "${command}"
    start_date=$( eval "${command}" )
    command="aws redshift describe-reserved-nodes --region \"${aws_region}\" --reserved-node-id \"${db}\" --query 'ReservedNodes[].Duration' --output text"
    command_message "${command}"
    dur_secs=$( eval "${command}" )
    command="date \"+%s\""
    command_message "${command}"
    curr_secs=$( eval "${command}" )
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
    command="echo \"(7 * 84600)\" | bc"
    command_message "${command}"
    test_secs=$( eval "${command}" )
    command="echo \"(${exp_secs} - ${curr_secs})\" | bc"
    command_message "${command}"
    left_secs=$( eval "${command}" )
    if [ "${left_secs}" -lt "${test_secs}" ]; then
      increment_secure   "Reserved Redshift instance \"${db}\" has more than 7 days remaining"
    else
      increment_insecure "Reserved Redshift instance \"${db}\" has less than 7 days remaining"
    fi
  done
}
