# audit_aws_creds
#
# Refer to Section(s) 1.3  Page(s) 15-6 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.4  Page(s) 17-8 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.12 Page(s) 33-4 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_creds () {
  verbose_message "Credentials"
  aws iam generate-credential-report 2>&1 > /dev/null
  entries=$( aws iam get-credential-report --query 'Content' --output text | $base64_d | cut -d, -f1,4,5,6,9,10,11,14,15,16 | sed '1 d' | awk -F '\n' '{print $1}' )
  for entry in $entries; do
    aws_user=$( echo "$entry" | cut -d, -f1 )
    aws_pass=$( echo "$entry" | cut -d, -f2 )
    aws_last=$( echo "$entry" | cut -d, -f3 )
    aws_rot=$( echo "$entry" | cut -d, -f4 )
    key1_use=$( echo "$entry" | cut -d, -f5 )
    key1_rot=$( echo "$entry" | cut -d, -f6 )
    key1_last=$( echo "$entry" | cut -d, -f7 )
    key2_use=$( echo "$entry" | cut -d, -f8 )
    key2_rot=$( echo "$entry" | cut -d, -f9 )
    key2_last=$( echo "$entry" | cut -d, -f10 )
    cur_sec=$( date "+%s" )
    if [ "$aws_user" = "<root_account>" ]; then
      if [ "$key1_use" = "true" ] || [ "$key2_use" = "true" ]; then
        increment_insecure "Account $aws_user is using access keys"
      else
        increment_secure "Account $aws_user isn't using access keys"
      fi
    else
      if [ "$aws_pass" = "false" ] && [ "$key1_use" = "false" ] && [ "$key2_use" = "false" ]; then
          increment_insecure "Account $aws_user does not use any AWS credentials consider removing account"
      else
        if [ "$aws_pass" = "true" ]; then 
          if [ "$( echo $aws_last |grep '[0-9]' )" ]; then
            if [ "$os_name" = "Linux" ]; then
              aws_sec=$( date -d "$aws_last" "+%s" )
            else
              aws_sec=$( date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$aws_last" "+%s" )
            fi
            aws_days=$( echo "($cur_sec - $aws_sec)/84600" | bc )
            if [ $aws_days -gt 90 ]; then
              increment_insecure "Account $aws_user has not used AWS Console credentials in over 90 days consider locking access"
            else
              increment_secure "Account $aws_user has used AWS Console credentials in the past 90 days"
            fi
          fi
          if [ "$( echo "$aws_rot" |grep '[0-9]' )" ]; then
            if [ "$os_name" = "Linux" ]; then
              rot_sec=$( date -d "$aws_last" "+%s" )
            else
              rot_sec=$( date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$aws_last" "+%s" )
            fi
            rot_days=$( echo "($rot_sec - $cur_sec)/84600" | bc )
            if [ $rot_days -gt 90 ]; then
              increment_insecure "Account $aws_user will not rotate their AWS Console password in the next 90 days consider locking access"
            else
              increment_secure "Account $aws_user will rotate their AWS Console password in the past 90 days"
            fi
          else
            increment_insecure "Account $aws_user will not rotate their AWS Console password in the next 90 days consider locking access"
          fi
        fi
        if [ "$key1_use" = "true" ]; then
          if [ "$os_name" = "Linux" ]; then
            key1_sec=$( date -d "$key1_last" "+%s" )
          else
            key1_sec=$( date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key1_last" "+%s" )
          fi
          key1_days=$( echo "($cur_sec - $key1_sec)/84600" | bc )
          if [ $key1_days -gt 90 ]; then
            increment_insecure "Account $aws_user has not used AWS API credentials in over 90 days consider removing keys"
          else
            increment_secure "Account $aws_user has used AWS API credentials in the past 90 days"
          fi
          if [ "$( echo "$key1_rot" |grep '[0-9]' )" ]; then
            if [ "$os_name" = "Linux" ]; then
              rot_sec=$( date -d "$key1_rot" "+%s" )
            else
              rot_sec=$( date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key1_rot" "+%s" )
            fi
            rot_days=$( echo "($cur_sec - $rot_sec)/84600" | bc )
            if [ $rot_days -gt 90 ]; then
              increment_insecure "Account $aws_user will not rotate their AWS API credentials in the next 90 days"
            else
              increment_secure "Account $aws_user has rotated their AWS API credentials in the last 90 days"
            fi
          else
            increment_insecure "Account $aws_user will not rotate their AWS API credentials in the next 90 days"
          fi
        fi
        if [ "$key2_use" = "true" ]; then
          if [ "$os_name" = "Linux" ]; then
            key2_sec=$( date -d "$key2_last" "+%s" )
          else
            key2_sec=$( date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key2_last" "+%s" )
          fi
          key2_days=$( echo "($cur_sec - $key2_sec)/84600" | bc )
          if [ $key2_days -gt 90 ]; then
            increment_insecure "Account $aws_user has not used AWS SOA credentials in over 90 days consider removing keys"
          else
            increment_secure "Account $aws_user has used AWS SOA credentials in the past 90 days"
          fi
          if [ "$( echo $key2_rot |grep '[0-9]' )" ]; then
            if [ "$os_name" = "Linux" ]; then
              rot_sec=$( date -d "$key2_rot" "+%s" )
            else
              rot_sec=$( date -j -f "%Y-%m-%dT%H:%M:%S+00:00" "$key2_rot" "+%s" )
            fi
            rot_days=$( echo "($cur_sec - $rot_sec)/84600" | bc )
            if [ $rot_days -gt 90 ]; then
              increment_insecure "Account $aws_user will not rotate their AWS SOA credentials in the next 90 days"
            else
              increment_secure "Account $aws_user has rotated their AWS SOA credentials in the last 90 days"
            fi
          else
            increment_insecure "Account $aws_user will not rotate their AWS SOA credentials in the next 90 days"
          fi
        fi
      fi
    fi
  done
}

