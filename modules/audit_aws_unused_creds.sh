# audit_aws_unused_creds
#
# AWS IAM users can access AWS resources using different types of credentials,
# such as passwords or access keys. It is recommended that all credentials
# that have been unused in 90 or greater days be removed or deactivated.
#
# Disabling or removing unnecessary credentials will reduce the window of
# opportunity for credentials associated with a compromised or abandoned
# account to be used.
#
# Refer to Section(s) 1.3 Page(s) 15-6 CIS AWS Foundations Benchmark v1.0.0
#.

audit_aws_unused_creds () {
	entries=`aws iam get-credential-report --query 'Content' --output text | $base_d | cut -d, -f1,4,5,9,11,14,16 | grep -v "<root_account>" |sed '1 d' |awk -F '\n' '{print $1}'`
	for entry in $entries; do
    aws_user=`echo "$entry" |cut -d, -f1`
    aws_pass=`echo "$entry" |cut -d, -f2`
    aws_last=`echo "$entry" |cut -d, -f3`
    key1_use=`echo "$entry" |cut -d, -f4`
    key1_last=`echo "$entry" |cut -d, -f5`
    key2_use=`echo "$entry" |cut -d, -f6`
    key2_last=`echo "$entry" |cut -d, -f7`
    if [ "$aws_pass" = "false" ] && [ "$key1_use" = "false" ] && [ "$key2_use" = "false" ]; then
        total=`expr $total + 1`
        insecure=`expr $insecure + 1`
        echo "Warning:   Account $aws_user does not use any AWS credentials consider removing account [$insecure Warnings]"
    else
      if [ "$aws_pass" = "true" ]; then 
        if [ "`echo $aws_last |grep '[0-9]'`" ]; then
          total=`expr $total + 1`
          curr_sec=`date "+%s"`
          aws_sec=`date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$aws_last" "+%s"`
          aws_days=`echo "($curr_sec - $aws_sec)/84600" |bc`
          if [ $aws_days -gt 90 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Account $aws_user has not used AWS Console credentials in over 90 days consider locking access [$insecure Warnings]"
          else
            secure=`expr $secure + 1`
            echo "Secure:    Account $aws_user has used AWS Console credentials in the past 90 days [$secure Passes]"
          fi
        fi
      fi
      if [ "$key1_use" = "true" ]; then
        total=`expr $total + 1`
        key1_sec=`date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key1_last" "+%s"`
        key1_days=`echo "($curr_sec - $key1_sec)/84600" |bc`
        if [ $key1_days -gt 90 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Account $aws_user has not used newer AWS API credentials in over 90 days consider removing keys [$insecure Warnings]"
        else
          secure=`expr $secure + 1`
          echo "Secure:    Account $aws_user has used newer API credentials in the past 90 days [$secure Passes]"
        fi
      fi
      if [ "$key2_use" = "true" ]; then
        total=`expr $total + 1`
        key2_sec=`date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key2_last" "+%s"`
        key2_days=`echo "($curr_sec - $key2_sec)/84600" |bc`
        if [ $key2_days -gt 90 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Account $aws_user has not used older AWS API credentials in over 90 days consider removing keys [$insecure Warnings]"
        else
          secure=`expr $secure + 1`
          echo "Secure:    Account $aws_user has used older API credentials in the past 90 days [$secure Passes]"
        fi
      fi
    fi
  done
}

