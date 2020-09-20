# audit_aws_keys
#
# Refer to Section(s) 2.8 Page(s) 85-6 CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/unnecessary-ssh-public-keys.html
# Refer to https://www.cloudconformity.com/conformity-rules/KMS/key-rotation-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/KMS/unused-customer-master-key.html
#.

audit_aws_keys () {
  verbose_message "KMS Keys"
  keys=$( aws kms list-keys --query Keys --output text )
  if [ "$keys" ]; then
    for key in $keys; do
      # Check key is enabled
      check=$( aws kms get-key-rotation-status --key-id $key --query 'KeyMetadata' | grep Enabled | grep true )
      if [ ! "$check" ]; then
        increment_insecure "Key $key is not enabled"
        verbose_message "" fix
        verbose_message "aws kms schedule-key-deletion --key-id $key --pending-window-in-days $aws_days_to_key_deletion" fix
        verbose_message "" fix
      else
        increment_secure "Key $key is enabled"
      fi
      # Check that key rotation is enabled
      check=$( aws kms get-key-rotation-status --key-id $key |grep KeyRotationEnabled | grep true )
      if [ ! "$check" ]; then
        increment_insecure "Key $key does not have key rotation enabled"
        verbose_message "" fix
        verbose_message "aws cloudtrail update-trail --name <trail_name> --kms-id <cloudtrail_kms_key> aws kms put-key-policy --key-id <cloudtrail_kms_key> --policy <cloudtrail_kms_key_policy>" fix
        verbose_message "aws kms enable-key-rotation --key-id <cloudtrail_kms_key>" fix
        verbose_message "" fix
      else
        increment_secure "Key $key has rotation enabled"
      fi
    done
  else
    increment_insecure "No Keys are being used"
  fi
  # Check for SSH keys
  users=$( aws iam list-users --query 'Users[].UserName' --output text )
  for user in $users; do
    check=$( aws iam list-ssh-public-keys --region $aws_region --user-name $user | grep -c Active )
    if [ "$check" -gt 1 ]; then
      increment_insecure "User $user does has more than one active SSH key"
    else
      if [ "$check" -eq 0 ]; then
        increment_secure "User $user does not have any active SSH key"
      else
        increment_secure "User $user does not have more than one active SSH key"
      fi
    fi 
  done
}

