# check_aws_password_policy
#
# Check AWS Password Policy
#
# This requires the AWS CLI to be installed and configured
#.

check_aws_password_policy () {
  param=$1
  value=$2
  switch=$3
  policy=$( aws iam get-account-password-policy 2> /dev/null | grep "$param" )
  clifix="aws iam update-account-password-policy $switch"
  check=$( grep "$param" "$policy" | cut -f2 -d: | sed "s/ //g" | sed "s/,//g" )
  if [ "$check" = "$value" ]; then
    increment_secure "The password policy has $param set to $value"
  else
    increment_insecure "The password policy does not have $param set to $value"
    lockdown_command "$clifix"
  fi
}