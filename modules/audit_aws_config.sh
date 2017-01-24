# audit_aws_config
#
# AWS Config is a web service that performs configuration management of
# supported AWS resources within your account and delivers log files to you.
# The recorded information includes the configuration item (AWS resource),
# relationships between configuration items (AWS resources), any
# configuration changes between resources. It is recommended to enable
# AWS Config be enabled in all regions.
#
# The AWS configuration item history captured by AWS Config enables security
# analysis, resource change tracking, and compliance auditing.
#
# Refer to Section(s) 2.5 Page(s) 79-80 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_config () {
	check=`aws configservice describe-configuration-recorders`
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
}

