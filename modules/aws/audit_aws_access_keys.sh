#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_access_keys
# 
# Check AWS Access Keys
#
# Refer to Section(s) 1.23 Page(s) 66-7 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_access_keys () {
  print_function  "audit_aws_access_keys"
  verbose_message "Access Keys"   "check"
  command="aws iam generate-credential-report > /dev/null 2>&1"
  command_message "${command}"
  eval "${command}"
  command="aws iam get-credential-report --query 'Content' --output text | \"${base64_d}\" | cut -d, -f1,4,9,11,14,16 | sed '1 d' | grep -v '<root_account>' | awk -F '\\\n' '{print \$1}'"
  command_message "${command}"
  eval "${command}"
  for entry in ${entries}; do
    aws_user=$( echo "${entry}" | cut -d, -f1 )
    key1_use=$( echo "${entry}" | cut -d, -f3 )
    key1_last=$( echo "${entry}" | cut -d, -f4 )
    key2_use=$( echo "${entry}" | cut -d, -f5 )
    key2_last=$( echo "${entry}" | cut -d, -f6 )
    if [ "${key1_use}" = "true" ] && [ "${key1_last}" = "N/A" ]; then
      increment_insecure  "Account \"${aws_user}\" has key access enabled but has not used their AWS API credentials consider removing keys"
      command="aws iam list-access-keys --user-name \"${aws_user}\" --query \"AccessKeyMetadata[].{AccessKeyId:AccessKeyId, Status:Status}\" --output text | grep Active | awk '{print \$1}'"
      command_message "${command}"
      key_ids=$( eval "${command}" )
      for key_id in ${key_ids}; do
        lockdown_command="aws iam delete-access-key --access-key \"${key_id}\" --user-name \"${aws_user}\""
        lockdown_message="Key \"${key_id}\" for user \"${aws_user}\" to disabled"
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      done
    else
      increment_secure    "Account \"${aws_user}\" has key access enabled and has used their AWS API credentials"
    fi
    if [ "${key2_use}" = "true" ] && [ "${key2_last}" = "N/A" ]; then
      increment_insecure  "Account \"${aws_user}\" has key access enabled but has not used their AWS API credentials consider removing keys"
    else
      increment_secure    "Account \"${aws_user}\" has key access enabled and has used their AWS API credentials"
    fi
  done
}