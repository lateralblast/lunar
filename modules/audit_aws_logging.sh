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
# CloudTrail logs a record of every API call made in your AWS account.
# These logs file are stored in an S3 bucket. It is recommended that the bucket
# policy or access control list (ACL) applied to the S3 bucket that CloudTrail
# logs to prevents public access to the CloudTrail logs.
#
# Allowing public access to CloudTrail log content may aid an adversary in
# identifying weaknesses in the affected account's use or configuration.
#
# Refer to Section(s) 2.1 Page(s) 70-1 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.2 Page(s) 72-3 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.3 Page(s) 74-5 CIS AWS Foundations Benchmark v1.1.0
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
  check=`aws cloudtrail describe-trails |grep LogFileValidationEnabled |grep true`
  total=`expr $total + 1`
  if [ "$check" ]; then
    secure=`expr $secure + 1`
    echo "Secure:    CloudTrail log file validation is enabled [$secure Passes]"
  else
    insecure=`expr $insecure + 1`
    echo "Warning:   CloudTrail log file validation is not enabled [$insecure Warnings]"
  fi
  buckets=`aws cloudtrail describe-trails --query 'trailList[*].S3BucketName' --output text`
  for bucket in $buckets; do
    total=`expr $total + 1`
    grants=`aws s3api get-bucket-acl --bucket $bucket |grep URI |grep AllUsers`
    if [ "$grants" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   CloudTrail log file bucket $bucket grants access to Principal AllUsers [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    CloudTrail log file bucket $bucket does not grant access to Principal AllUsers [$secure Passes]"
    fi
    total=`expr $total + 1`
    grants=`aws s3api get-bucket-acl --bucket $bucket |grep URI |grep AuthenticatedUsers`
    if [ "$grants" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   CloudTrail log file bucket $bucket grants access to Principal AuthenticatedUsers [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    CloudTrail log file bucket $bucket does not grant access to Principal AuthenticatedUsers [$secure Passes]"
    fi
    total=`expr $total + 1`
    grants=`aws s3api get-bucket-policy --bucket $bucket --query Policy |tr "}" "\n" |grep Allow |grep "*"`
    if [ "$grants" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   CloudTrail log file bucket $bucket grants access to Principal * [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    CloudTrail log file bucket $bucket does not grant access to Principal * [$secure Passes]"
    fi
  done
}

