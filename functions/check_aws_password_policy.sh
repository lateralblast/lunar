#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_aws_password_policy
#
# Check AWS Password Policy
#
# This requires the AWS CLI to be installed and configured
#.

check_aws_password_policy () {
  param="$1"
  value="$2"
  switch="$3"
  policy=$( aws iam get-account-password-policy 2> /dev/null | grep "${param}" )
  cli_fix="aws iam update-account-password-policy ${switch}"
  check=$( grep "${param}" "${policy}" | cut -f2 -d: | sed "s/ //g" | sed "s/,//g" )
  secure_string="The password policy has \"${param}\" set to \"${value}\""
  insecure_string="The password policy does not has \"${param}\" set to \"${value}\""
  verbose_message "${secure_string}" "check"
  if [ "${check}" = "${value}" ]; then
    increment_secure   "${secure_string}"
  else
    increment_insecure "${insecure_string}"
    lockdown_command="${cli_fix}"
    lockdown_message="IAM Account password policy parameter \"${param}\" to \"${value}\""
    execute_lockdown "${lockdown_command}" "${lockdown_message}"
  fi
}