# audit_aws_mfa
#
# Multi-Factor Authentication (MFA) adds an extra layer of protection on top
# of a user name and password. With MFA enabled, when a user signs in to an
# AWS website, they will be prompted for their user name and password as well
# as for an authentication code from their AWS MFA device. It is recommended
# that MFA be enabled for all accounts that have a console password.
# 
# Enabling MFA provides increased security for console access as it requires
# the authenticating principal to possess a device that emits a time-sensitive
# key and have knowledge of a credential.
#
# http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html
#
# Refer to Section(s) 1.2 Page(s) 12-4 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_mfa () {
	entries=`aws iam get-credential-report --query 'Content' --output text | $base_d | cut -d, -f1,4,8 | sed '1 d' |awk -F '\n' '{print $1}'`
	for entry in $entries; do
    total=`expr $total + 1`
    user=`echo "$entry" |cut -d, -f1`
    pass=`echo "$entry" |cut -d, -f2`
    mfa=`echo "$entry" |cut -d, -f3`
    if [ "$user" = "<root_account>" ]; then
      if [ "$mfa" = "false" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Account $user does not have MFA enabled [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    Account $user has MFA enabled [$secure Passes]"
      fi
    else
      if [ "$pass" != "false" ]; then
        if [ "$mfa" = "false" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Account $user does not have MFA enabled [$insecure Warnings]"
        else
          secure=`expr $secure + 1`
          echo "Secure:    Account $user has MFA enabled [$secure Passes]"
        fi
      else
        secure=`expr $secure + 1`
        echo "Secure:    Account $user does not log into console [$secure Passes]"
      fi
    fi
  done
}

