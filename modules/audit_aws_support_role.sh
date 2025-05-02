#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_support_role
#
# Check AWS Support Role
#
# Refer to Section(s) 1.22 Page(s) 64-5 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_support_role () {
  verbose_message "Support" "check"
  arn=$( aws iam list-policies --query "Policies[?PolicyName == 'AWSSupportAccess']" | grep Arn | awk -F': ' '{print $2}' | sed "s/ //g" | sed "s/,//g" | sed "s/\"//g" )
  roles=$( aws iam list-entities-for-policy --policy-arn "${arn}" | grep PolicyRoles | cut -f2 -d: )
  users=$( aws iam list-entities-for-policy --policy-arn "${arn}" | grep PolicyGroups | cut -f2 -d: )
  groups=$( aws iam list-entities-for-policy --policy-arn "${arn}" | grep PolicyUsers | cut -f2 -d: )
  if [ -z "${roles}" ] && [ -z "${users}" ] && [ -z "${groups}" ]; then
    increment_secure   "A support role has been created to manage incidents"
  else
    increment_insecure "There is no support role to manage incidents"
  fi
}

