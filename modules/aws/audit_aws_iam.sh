#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_iam
#
# Check AWS IAM
#
# Refer to Section(s) 1.1  Page(s) 10-1  CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.18 Page(s) 46-57 CIS AWS Foundations Benchmark v1.1.0
#
# Refer to http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/unused-iam-group.html
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/unused-iam-user.html
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/iam-user-policies.html
#.

audit_aws_iam () {
  # Root account should only be used sparingly, admin functions and responsibilities should be delegated
  print_function  "audit_aws_iam"
  verbose_message "IAM"   "check"
  command="aws iam generate-credential-report > /dev/null 2>&1"
  command_message "${command}"
  eval "${command}"
  command="date +%Y-%m"
  command_message "${command}"
  date_test=$( eval "${command}" )
  command="aws iam get-credential-report --query 'Content' --output text | \"${base64_d}\" | cut -d, -f1,5,11,16 | grep -B1 '<root_account>' | cut -f2 -d, | cut -f1,2 -d- | grep '[0-9]'"
  command_message "${command}"
  last_login=$( eval "${command}" )
  if [ "${date_test}" = "${last_login}" ]; then
    increment_insecure "Root account appears to be being used regularly"
  else
    increment_secure   "Root account does not appear to be being used frequently"
  fi
  # Check to see if there is an IAM master role
  command="aws iam get-role --role-name \"${aws_iam_master_role}\" 2> /dev/null"
  command_message "${command}"
  check=$( eval "${command}" )
  if [ -n "${check}" ]; then 
    increment_secure   "IAM Master role \"${aws_iam_master_role}\" ${exists}"
  else
    increment_insecure "IAM Master role \"${aws_iam_master_role}\" does not exist"
    verbose_message    "cd aws" "fix"
    verbose_message    "aws iam create-role --role-name ${aws_iam_master_role} --assume-role-policy-document file://account-creation-policy.json" "fix"
    verbose_message    "aws iam put-role-policy --role-name ${aws_iam_master_role} --policy-name ${aws_iam_master_role} --policy-document file://iam-master-policy.json" "fix"
  fi
  # Check there is an IAM manager role
  command="aws iam get-role --role-name \"${aws_iam_manager_role}\" 2> /dev/null"
  command_message "${command}"
  check=$( eval "${command}" )
  if [ -n "${check}" ]; then 
    increment_secure   "IAM Manager role \"${aws_iam_manager_role}\" ${exists}"
  else
    increment_insecure "IAM Manager role \"${aws_iam_manager_role}\" does not exist"
    verbose_message    "cd aws" "fix"
    verbose_message    "aws iam create-role --role-name ${aws_iam_master_role} --assume-role-policy-document file://account-creation-policy.json" "fix"
    verbose_message    "aws iam put-role-policy --role-name ${aws_iam_manager_role} --policy-name ${aws_iam_manager_role} --policy-document file://iam-manager-policy.json" "fix"
  fi
  # Check groups have members
  command="aws iam list-groups --query 'Groups[].GroupName' --output text"
  command_message "${command}"
  groups=$( eval "${command}" )
  for group in ${groups}; do
    command="aws iam get-group --group-name \"${group}\" --query \"Users\" --output text"
    command_message "${command}"
    users=$( eval "${command}" )
    if [ -n "${users}" ]; then
      increment_secure   "IAM group \"${group}\" is not empty"
    else
      increment_insecure "IAM group \"${group}\" is empty"
    fi
  done
  command="aws iam list-users --query 'Users[].UserName' --output text"
  command_message "${command}"
  users=$( eval "${command}" )
  for user in ${users}; do
    # Check for inactive users
    command="aws iam list-access-keys --user-name \"${user}\" --query \"AccessKeyMetadata\" --output text"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure   "IAM user \"${user}\" is active"
    else
      increment_insecure "IAM user \"${user}\" is not active"
      verbose_message    "aws iam delete-user --user-name ${user}" "fix"
    fi
    # Check users do not have attached policies, they should be members of groups which have those policies
    command="aws iam list-attached-user-policies --user-name \"${user}\" --query \"AttachedPolicies[].PolicyArn\" --output text"
    command_message "${command}"
    policies=$( eval "${command}" )
    if [ -n "${policies}" ]; then
      for policy in ${policies}; do
        increment_insecure "IAM user \"${user}\" has attached policy \"${policy}\""
        verbose_message    "aws iam detach-user-policy --user-name ${user} --policy-arn ${policy}" "fix"
      done
    else
      increment_secure "IAM user \"${user}\" does not have attached policies"
    fi
  done
}

