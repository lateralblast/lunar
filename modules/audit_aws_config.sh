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
#
# Ensure that AWS Config service is enabled in all regions in order to have
# complete visibility over your AWS infrastructure configuration changes.
#
# Once enabled, the Config service detects your existing AWS resources and
# records their current configurations and any changes made to them later.
# The data recorded by this service can be extremely useful for your
# compliance team during security auditing or troubleshooting sessions,
# as it can determine how a resource was configured at a certain point in
# time and what relationships had with other resources.
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
  check=`aws configservice --region $aws_region --get-status |grep FAILED`
  if [ "$check" ]; then
    insecure=`expr $insecure + 1`
    echo "Warning:   AWS Config not enabled [$insecure Warnings]"
  else
    secure=`expr $secure + 1`
    echo "Secure:    AWS Config enabled [$secure Passes]"
  fi
}

