# audit_aws_mfa
#
# Refer to http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html
# Refer to http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html
# Refer to http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_physical.html#enable-hw-mfa-for-root
# Refer to Section(s) 1.2  Page(s) 12-4 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.13 Page(s) 35-6 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.14 Page(s) 37-8 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_mfa () {
  verbose_message "MFA"
  entries=$( aws iam get-credential-report --query 'Content' --output text | $base64_d | cut -d, -f1,4,8 | sed '1 d' | awk -F '\n' '{print $1}' )
  for entry in $entries; do
    user=$( echo "$entry" | cut -d, -f1 )
    pass=$( echo "$entry" | cut -d, -f2 )
    mfa=$( echo "$entry" | cut -d, -f3 )
    if [ "$user" = "<root_account>" ]; then
      if [ "$mfa" = "false" ]; then
        increment_insecure "Account $user does not have MFA enabled"
      else
        increment_secure "Account $user has MFA enabled"
      fi
    else
      if [ "$pass" != "false" ]; then
        if [ "$mfa" = "false" ]; then
          increment_insecure "Account $user does not have MFA enabled"
        else
          increment_secure "Account $user has MFA enabled"
        fi
      else
        increment_secure "Account $user does not log into console"
      fi
    fi
  done
  mfa_check=$( aws iam get-account-summary | grep "AccountMFAEnabled" | cut -f1 -d: | sed "s/ //g" | sed "s/,//g" )
  if [ "$mfa_check" = "1" ]; then
    increment_secure "The root account has MFA enabled"
    mfa_check=$( iaws iam list-virtual-mfa-devices | grep "SerialNumber" | grep -c "root_account" )
    if [ "$mfa_check" = "0" ]; then
      increment_secure "The root account does not have a virtual MFA"
    else
      increment_insecure "The root account does not have a hardware MFA"
    fi
  else
    increment_insecure "The root account does not have MFA enabled"
    increment_insecure "The root account does not a hardware MFA"
  fi
}