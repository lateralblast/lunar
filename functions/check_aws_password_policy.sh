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
	policy=`aws iam get-account-password-policy 2> /dev/null |grep "$param"`
	clifix="aws iam update-account-password-policy $switch"
	total=`expr $total + 1`
	check=`echo "$policy" |grep "$param" |cut -f2 -d: |sed "s/ //g" |sed "s/,//g"`
    if [ "$check" = "$value" ]; then
      secure=`expr $secure + 1`
      echo "Warning:   The password policy has $param set to $value [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   The password policy does not have $param set to $value [$insecure Warnings]"
      verbose_message "" fix
      verbose_message "$clifix" fix
      verbose_message "" fix
    fi
}