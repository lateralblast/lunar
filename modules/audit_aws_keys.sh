# audit_aws_keys
#
# AWS Key Management Service (KMS) allows customers to rotate the backing key
# which is key material stored within the KMS which is tied to the key ID of
# the Customer Created customer master key (CMK). It is the backing key that
# is used to perform cryptographic operations such as encryption and decryption.
# Automated key rotation currently retains all prior backing keys so that
# decryption of encrypted data can take place transparently. It is recommended
# that CMK key rotation be enabled.
#
# Rotating encryption keys helps reduce the potential impact of a compromised
# key as data encrypted with a new key cannot be accessed with a previous key
# that may have been exposed.
#
# Refer to Section(s) 2.8 Page(s) 85-6 CIS AWS Foundations Benchmark v1.1.0
#
# Removing unnecessary IAM SSH public keys will lower the risk of unauthorized
# access to your AWS CodeCommit repositories and adhere to AWS IAM security best
# practices.
#
# Refer to: https://www.cloudconformity.com/conformity-rules/IAM/unnecessary-ssh-public-keys.html
#.

audit_aws_keys () {
	keys=`aws kms list-keys --query Keys --output text`
  total=`expr $total + 1`
  if [ "$keys" ]; then
  	for key in $keys; do
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

