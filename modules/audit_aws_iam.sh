# audit_aws_iam
#
# Refer to http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
# Refer to Section(s) 1.1  Page(s) 10-1  CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.18 Page(s) 46-57 CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/unused-iam-group.html
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/unused-iam-user.html
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/iam-user-policies.html
#.

audit_aws_iam () {
  # Root account should only be used sparingly, admin functions and responsibilities should be delegated
  verbose_message "IAM"
  aws iam generate-credential-report 2>&1 > /dev/null
  date_test=$( date +%Y-%m )
  last_login=$( aws iam get-credential-report --query 'Content' --output text | $base64_d | cut -d, -f1,5,11,16 | grep -B1 '<root_account>' | cut -f2 -d, | cut -f1,2 -d- | grep '[0-9]' )
  if [ "$date_test" = "$last_login" ]; then
    increment_insecure "Root account appears to be being used regularly"
  else
    increment_secure "Root account does not appear to be being used frequently"
  fi
  # Check to see if there is an IAM master role
  check=$( aws iam get-role --role-name $aws_iam_master_role 2> /dev/null )
  if [ "$check" ]; then 
    increment_secure "IAM Master role $aws_iam_master_role exists"
  else
    increment_insecure "IAM Master role $aws_iam_master_role does not exist"
    verbose_message "" fix
    verbose_message "cd aws" fix
    verbose_message "aws iam create-role --role-name $aws_iam_master_role --assume-role-policy-document file://account-creation-policy.json" fix
    verbose_message "aws iam put-role-policy --role-name $aws_iam_master_role --policy-name $aws_iam_master_role --policy-document file://iam-master-policy.json" fix
    verbose_message "" fix
  fi
  # Check there is an IAM manager role
  check=$( aws iam get-role --role-name $aws_iam_manager_role 2> /dev/null )
  if [ "$check" ]; then 
    increment_secure "IAM Manager role $aws_iam_manager_role exists"
  else
    increment_insecure "IAM Manager role $aws_iam_manager_role does not exist"
    verbose_message "" fix
    verbose_message "cd aws" fix
    verbose_message "aws iam create-role --role-name $aws_iam_master_role --assume-role-policy-document file://account-creation-policy.json" fix
    verbose_message "aws iam put-role-policy --role-name $aws_iam_manager_role --policy-name $aws_iam_manager_role --policy-document file://iam-manager-policy.json" fix
    verbose_message "" fix
  fi
  # Check groups have members
  groups=$( aws iam list-groups --query 'Groups[].GroupName' --output text )
  for group in $groups; do
    users=$( aws iam get-group --group-name $group --query "Users" --output text )
    if [ "$users" ]; then
      increment_secure "IAM group $group is not empty"
    else
      increment_insecure "IAM group $group is empty"
    fi
  done
  users=$( aws iam list-users --query 'Users[].UserName' --output text )
  for user in $users; do
    # Check for inactive users
    check=$( aws iam list-access-keys --user-name $user --query "AccessKeyMetadata" --output text )
    if [ "$check" ]; then
      increment_secure "IAM user $user is active"
    else
      increment_insecure "IAM user $user is not active"
      verbose_message "" fix
      verbose_message "aws iam delete-user --user-name $user" fix
      verbose_message "" fix
    fi
    # Check users do not have attached policies, they should be members of groups which have those policies
    policies=$( aws iam list-attached-user-policies --user-name $user --query "AttachedPolicies[].PolicyArn" --output text )
    if [ "$policies" ]; then
      for policy in $policies; do
        increment_insecure "IAM user $user has attached policy $policy"
        verbose_message "" fix
        verbose_message "aws iam detach-user-policy --user-name $user --policy-arn $policy" fix
        verbose_message "" fix
      done
    else
      increment_secure "IAM user $user does not have attached policies"
    fi
  done
}

