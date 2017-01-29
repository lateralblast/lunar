# audit_aws_keys
#
# Refer to Section(s) 2.8 Page(s) 85-6 CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/unnecessary-ssh-public-keys.html
# Refer to https://www.cloudconformity.com/conformity-rules/KMS/key-rotation-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/KMS/unused-customer-master-key.html
#.

audit_aws_keys () {
	keys=`aws kms list-keys --query Keys --output text`
  total=`expr $total + 1`
  if [ "$keys" ]; then
  	for key in $keys; do
      # Check key is enabled
      total=`expr $total + 1`
      check=`aws kms get-key-rotation-status --key-id $key --query 'KeyMetadata' |grep Enabled |grep true`
      if [ ! "$check" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Key $key is not enabled [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws kms schedule-key-deletion --key-id $key --pending-window-in-days $aws_days_to_key_deletion" fix
        funct_verbose_message "" fix
      else
        secure=`expr $secure + 1`
        echo "Secure:    Key $key is enabled [$secure Passes]"
      fi
      # Check that key rotation is enabled
      total=`expr $total + 1`
      check=`aws kms get-key-rotation-status --key-id $key |grep KeyRotationEnabled |grep true`
      if [ ! "$check" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Key $key does not have key rotation enabled [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws cloudtrail update-trail --name <trail_name> --kms-id <cloudtrail_kms_key> aws kms put-key-policy --key-id <cloudtrail_kms_key> --policy <cloudtrail_kms_key_policy>" fix
        funct_verbose_message "aws kms enable-key-rotation --key-id <cloudtrail_kms_key>" fix
        funct_verbose_message "" fix
      else
        secure=`expr $secure + 1`
        echo "Secure:    Key $key has rotation enabled [$secure Passes]"
      fi
    done
  else
    insecure=`expr $insecure + 1`
    echo "Warning:   No Keys are being used [$insecure Warnings]"
  fi
  # Check for SSH keys
  users=`aws iam list-users --query 'Users[].UserName' --output text`
  for user in $users; do
    total=`expr $total + 1`
    check=`aws iam list-ssh-public-keys --region $aws_region --user-name $user |grep Active |wc -l`
    if [ "$check" -gt 1 ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   User $user does has more than one active SSH key [$secure Passes]"
    else
      if [ "$check" -eq 0 ]; then
        secure=`expr $secure + 1`
        echo "Secure:    User $user does not have any active SSH key [$secure Passes]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    User $user does not have more than one active SSH key [$secure Passes]"
      fi
    fi 
  done
}

