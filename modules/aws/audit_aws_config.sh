#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_config
#
# Check AWS Config
#
# Refer to https://www.cloudconformity.com/conformity-rules/Config/aws-config-enabled.html
#.

audit_aws_config () {
  print_function  "audit_aws_config"
  check_message   "Config"
	command="aws configservice describe-configuration-recorders --region \"${aws_region}\""
  command_message "${command}"
  check=$( eval   "${command}" )
  if [ ! "${check}" ]; then
    inc_insecure "AWS Configuration Recorder not enabled"
    exec_lockdown   "aws configservice start-configuration-recorder" "Configuration Recorder Service to enabled"
  else
    inc_secure   "AWS Configuration Recorder enabled"
  fi
  command="aws configservice --region \"${aws_region}\" get-status | grep FAILED"
  command_message "${command}"
  check=$( eval   "${command}" )
  if [ "${check}" ]; then
    inc_insecure "AWS Config not enabled"
  else
    inc_secure   "AWS Config enabled"
  fi
}

