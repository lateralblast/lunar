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
  param="${1}"
  value="${2}"
  switch="${3}"
  print_function "check_aws_password_policy"
  command="aws iam get-account-password-policy 2> /dev/null | grep \"${param}\""
  command_message "${command}"
  policy=$( eval  "${command}" )
  cli_fix="aws iam update-account-password-policy ${switch}"
  command="grep \"${param}\" \"${policy}\" | cut -f2 -d: | sed \"s/ //g\" | sed \"s/,//g\""
  command_message "${command}"
  check=$( eval   "${command}" )
  secure_string="The password policy has \"${param}\" set to \"${value}\""
  insecure_string="The password policy does not has \"${param}\" set to \"${value}\""
  verbose_message "${secure_string}" "check"
  if [ "${check}" = "${value}" ]; then
    inc_secure   "${secure_string}"
  else
    inc_insecure "${insecure_string}"
    lock_command="${cli_fix}"
    lock_message="IAM Account password policy parameter \"${param}\" to \"${value}\""
    run_lockdown "${lock_command}" "${lock_message}"
  fi
}