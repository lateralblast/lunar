# audit_aws_access_keys
# 
# Refer to Section(s) 1.23 Page(s) 66-7 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_access_keys () {
  aws iam generate-credential-report 2>&1 > /dev/null
  entries=`aws iam get-credential-report --query 'Content' --output text | $base64_d | cut -d, -f1,4,9,11,14,16 | sed '1 d' |grep -v '<root_account>' |awk -F '\n' '{print $1}'`
  for entry in $entries; do
    aws_user=`echo "$entry" |cut -d, -f1`
    key1_use=`echo "$entry" |cut -d, -f3`
    key1_last=`echo "$entry" |cut -d, -f4`
    key2_use=`echo "$entry" |cut -d, -f5`
    key2_last=`echo "$entry" |cut -d, -f6`
    total=`expr $total + 1`
    if [ "$key1_use" = "true" ] && [ "$key1_last" = "N/A" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   Account $aws_user has key access enabled but has not used their AWS API credentials consider removing keys [$insecure Warnings]"
      key_ids=`aws iam list-access-keys --user-name $aws_user --query "AccessKeyMetadata[].{AccessKeyId:AccessKeyId, Status:Status}" --output text |grep Active |awk '{print $1}'`
      for key_id in $key_ids; do
        verbose_message "" fix
        verbose_message "aws iam delete-access-key --access-key $key_id --user-name $aws_user" fix
        verbose_message "" fix
      done
    else
      secure=`expr $secure + 1`
      echo "Secure:    Account $aws_user has key access enabled and has used their AWS API credentials [$secure Passes]"
    fi
    total=`expr $total + 1`
    if [ "$key2_use" = "true" ] && [ "$key2_last" = "N/A" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   Account $aws_user has key access enabled but has not used their AWS API credentials consider removing keys [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    Account $aws_user has key access enabled and has used their AWS API credentials [$secure Passes]"
    fi
  done
}

