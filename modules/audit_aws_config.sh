# audit_aws_config
#
# Refer to https://www.cloudconformity.com/conformity-rules/Config/aws-config-enabled.html
#.

audit_aws_config () {
  total=`expr $total + 1`
	check=`aws configservice describe-configuration-recorders --region $aws_region`
  if [ ! "$check" ]; then
    insecure=`expr $insecure + 1`
    echo "Warning:   AWS Configuration Recorder not enabled [$insecure Warnings]"
    funct_verbose_message "" fix
    funct_verbose_message "aws configservice start-configuration-recorder" fix
    funct_verbose_message "" fix
  else
    secure=`expr $secure + 1`
    echo "Secure:    AWS Configuration Recorder enabled [$secure Passes]"
  fi
  total=`expr $total + 1`
  check=`aws configservice --region $aws_region get-status |grep FAILED`
  if [ "$check" ]; then
    insecure=`expr $insecure + 1`
    echo "Warning:   AWS Config not enabled [$insecure Warnings]"
  else
    secure=`expr $secure + 1`
    echo "Secure:    AWS Config enabled [$secure Passes]"
  fi
}

