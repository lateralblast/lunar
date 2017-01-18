# audit_aws_logging
#
# AWS CloudTrail is a web service that records AWS API calls for your account
# and delivers log files to you. The recorded information includes the identity
# of the API caller, the time of the API call, the source IP address of the API
# caller, the request parameters, and the response elements returned by the AWS
# service. CloudTrail provides a history of AWS API calls for an account,
# including API calls made via the Management Console, SDKs, command line tools,
# and higher-level AWS services (such as CloudFormation).
#
# The AWS API call history produced by CloudTrail enables security analysis,
# resource change tracking, and compliance auditing. Additionally, ensuring that
# a multi-regions trail exists will ensure that unexpected activity occurring in
# otherwise unused regions is detected.
#
# Refer to Section(s) 2.1 Page(s) 70-1 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_logging () {
	check=`aws cloudtrail describe-trails |grep IsMultiRegionTrail |grep true`
	total=`expr $total + 1`
	if [ "$check" ]; then
		insecure=`expr $insecure + 1`
    echo "Warning:   CloudTrail is enabled in all regions [$insecure Warnings]"
	else
		secure=`expr $secure + 1`
    echo "Secure:    CloudTrail is not enabled in all regions [$secure Passes]"
	fi
}

