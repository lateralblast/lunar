# audit_aws_creds
#
# AWS IAM users can access AWS resources using different types of credentials,
# such as passwords or access keys. It is recommended that all credentials
# that have been unused in 90 or greater days be removed or deactivated.
#
# Disabling or removing unnecessary credentials will reduce the window of
# opportunity for credentials associated with a compromised or abandoned
# account to be used.
#
# Access keys consist of an access key ID and secret access key, which are used
# to sign programmatic requests that you make to AWS. AWS users need their own
# access keys to make programmatic calls to AWS from the AWS Command Line
# Interface (AWS CLI), Tools for Windows PowerShell, the AWS SDKs, or direct
# HTTP calls using the APIs for individual AWS services. It is recommended that
# all access keys be regularly rotated.
#
# Rotating access keys will reduce the window of opportunity for an access key
# that is associated with a compromised or terminated account to be used.
# Access keys should be rotated to ensure that data cannot be accessed with an
# old key which might have been lost, cracked, or stolen.
#
# Refer to Section(s) 1.3  Page(s) 15-6 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.4  Page(s) 17-8 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.12 Page(s) 33-4 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_creds () {
  aws iam generate-credential-report 2>&1 > /dev/null
	entries=`aws iam get-credential-report --query 'Content' --output text | $base_d | cut -d, -f1,4,5,6,9,10,11,14,15,16 | sed '1 d' |awk -F '\n' '{print $1}'`
	for entry in $entries; do
    aws_user=`echo "$entry" |cut -d, -f1`
    aws_pass=`echo "$entry" |cut -d, -f2`
    aws_last=`echo "$entry" |cut -d, -f3`
    aws_rot=`echo "$entry" |cut -d, -f4`
    key1_use=`echo "$entry" |cut -d, -f5`
    key1_rot=`echo "$entry" |cut -d, -f6`
    key1_last=`echo "$entry" |cut -d, -f7`
    key2_use=`echo "$entry" |cut -d, -f8`
    key2_rot=`echo "$entry" |cut -d, -f9`
    key2_last=`echo "$entry" |cut -d, -f10`
    curr_sec=`date "+%s"`
    if [ "$aws_user" = "<root_account>" ]; then
      total=`expr $total + 1`
      if [ "$key1_use" = "true" ] || [ "$key2_use" = "true" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Account $aws_user is using access keys [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Warning:   Account $aws_user isn't using access keys [$secure Passes]"
      fi
    else
      if [ "$aws_pass" = "false" ] && [ "$key1_use" = "false" ] && [ "$key2_use" = "false" ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Account $aws_user does not use any AWS credentials consider removing account [$insecure Warnings]"
      else
        if [ "$aws_pass" = "true" ]; then 
          if [ "`echo $aws_last |grep '[0-9]'`" ]; then
            total=`expr $total + 1`
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
          if [ "`echo "$aws_rot" |grep '[0-9]'`" ]; then
            total=`expr $total + 1`
            rot_sec=`date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$aws_last" "+%s"`
            rot_days=`echo "($rot_sec - $cur_sec)/84600" |bc`
            if [ $rot_days -gt 90 ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Account $aws_user will not rotate their AWS Console password in the next 90 days consider locking access [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Account $aws_user will rotate their AWS Console password in the past 90 days [$secure Passes]"
            fi
          else
            total=`expr $total + 1`
            insecure=`expr $insecure + 1`
            echo "Warning:   Account $aws_user will not rotate their AWS Console password in the next 90 days consider locking access [$insecure Warnings]"
          fi
        fi
        if [ "$key1_use" = "true" ]; then
          total=`expr $total + 1`
          key1_sec=`date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key1_last" "+%s"`
          key1_days=`echo "($curr_sec - $key1_sec)/84600" |bc`
          if [ $key1_days -gt 90 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Account $aws_user has not used AWS API credentials in over 90 days consider removing keys [$insecure Warnings]"
          else
            secure=`expr $secure + 1`
            echo "Secure:    Account $aws_user has used AWS API credentials in the past 90 days [$secure Passes]"
          fi
          total=`expr $total + 1`
          if [ "`echo "$key1_rot" |grep '[0-9]'`" ]; then
            rot_sec=`date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key1_rot" "+%s"`
            rot_days=`echo "($curr_sec - $rot_sec)/84600" |bc`
            if [ $rot_days -gt 90 ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Account $aws_user will not rotate their AWS API credentials in the next 90 days [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Account $aws_user has rotated their AWS API credentials in the last 90 days [$secure Passes]"
            fi
          else
            insecure=`expr $insecure + 1`
            echo "Warning:   Account $aws_user will not rotate their AWS API credentials in the next 90 days [$insecure Warnings]"
          fi
        fi
        if [ "$key2_use" = "true" ]; then
          total=`expr $total + 1`
          key2_sec=`date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key2_last" "+%s"`
          key2_days=`echo "($curr_sec - $key2_sec)/84600" |bc`
          if [ $key2_days -gt 90 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Account $aws_user has not used AWS SOA credentials in over 90 days consider removing keys [$insecure Warnings]"
          else
            secure=`expr $secure + 1`
            echo "Secure:    Account $aws_user has used AWS SOA credentials in the past 90 days [$secure Passes]"
          fi
          total=`expr $total + 1`
          if [ "`echo $key2_rot |grep '[0-9]'`" ]; then
            rot_sec=`date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key2_rot" "+%s"`
            rot_days=`echo "($curr_sec - $rot_sec)/84600" |bc`
            if [ $rot_days -gt 90 ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Account $aws_user will not rotate their AWS SOA credentials in the next 90 days [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Account $aws_user has rotated their AWS SOA credentials in the last 90 days [$secure Passes]"
            fi
          else
            insecure=`expr $insecure + 1`
            echo "Warning:   Account $aws_user will not rotate their AWS SOA credentials in the next 90 days [$insecure Warnings]"
          fi
        fi
      fi
    fi
  done
}

