# audit_aws_logging
#
# Refer to Section(s) 2.1 Page(s) 70-1 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.2 Page(s) 72-3 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.3 Page(s) 74-5 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.4 Page(s) 76-7 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.6 Page(s) 81-2 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.7 Page(s) 83-4 CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-s3-bucket-logging-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-bucket-mfa-delete-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-bucket-publicly-accessible.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-global-services-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-integrated-with-cloudwatch.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-log-file-integrity-validation.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-bucket-publicly-accessible.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-s3-bucket-logging-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudTrail/cloudtrail-global-services-logging-duplicated.html
#.

audit_aws_logging () {
  trails=`aws cloudtrail describe-trails --region $aws_region --query "trailList[].Name" --output text`
	if [ "$trails" ]; then
    for trail in $trails; do
      total=`expr $total + 1`
      # Check CloudTrail has MultiRegion enabled
      check=`aws cloudtrail describe-trails --region $aws_region --trail-name-list $trail --query "trailList[].IsMultiRegionTrail" |grep true`
      if [ "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail $trail is enabled in all regions [$secure Passes]"
    	else
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail $trail is not enabled in all regions [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws cloudtrail update-trail --name $trail --is-multi-region-trail" fix
        funct_verbose_message "" fix
      fi
      # Check CloudTrail is recording global events
      check=`aws cloudtrail describe-trails --region $aws_region --trail-name-list $trail --query "trailList[].IncludeGlobalServiceEvents" |grep true`
      if [ "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail $trail is recording global events [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail $trail is not recording global events [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws cloudtrail update-trail --name $trail --include-global-service-events" fix
        funct_verbose_message "" fix
      fi
      # Check log file validation is enabled
      total=`expr $total + 1`
      check=`aws cloudtrail describe-trails --region $aws_region --trail-name-list $trail --query "trailList[].LogFileValidationEnabled" |grep true`
      if [ "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail $trail log file validation is enabled [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail $trail log file validation is not enabled [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws cloudtrail update-trail --region $aws_region --name $trail --enable-log-file-validation" fix
        funct_verbose_message "" fix
      fi
      # 
    done
    buckets=`aws cloudtrail describe-trails --region $aws_region --query 'trailList[*].S3BucketName' --output text`
    # Check that CloudTrail buckets don't grant access to users it shouldn't
    # Check that CloudTrail bucket versioning is enable
    for bucket in $buckets; do
      total=`expr $total + 1`
      grants=`aws s3api get-bucket-acl --region $aws_region --bucket $bucket |grep URI |grep AllUsers`
      if [ "$grants" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail log file bucket $bucket grants access to Principal AllUsers [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail log file bucket $bucket does not grant access to Principal AllUsers [$secure Passes]"
      fi
      total=`expr $total + 1`
      grants=`aws s3api get-bucket-acl --region $aws_region --bucket $bucket |grep URI |grep AuthenticatedUsers`
      if [ "$grants" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail log file bucket $bucket grants access to Principal AuthenticatedUsers [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws s3api put-bucket-acl --region $aws_region --region $aws_region--bucket $bucket --acl private" fix
        funct_verbose_message "" fix
      else
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail log file bucket $bucket does not grant access to Principal AuthenticatedUsers [$secure Passes]"
      fi
      total=`expr $total + 1`
      grants=`aws s3api get-bucket-policy --region $aws_region --bucket $bucket --query Policy |tr "}" "\n" |grep Allow |grep "*"`
      if [ "$grants" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail log file bucket $bucket grants access to Principal * [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail log file bucket $bucket does not grant access to Principal * [$secure Passes]"
      fi
      logging=`aws s3api get-bucket-logging --region $aws_region --bucket $bucket`
      if [ ! "$logging" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail log file bucket $bucket does not have access logging enabled [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws s3api put-bucket-acl --region $aws_region --bucket $bucket --grant-write URI=http://acs.amazonaws.com/groups/s3/LogDelivery --grant-read-acp URI=http://acs.amazonaws.com/groups/s3/LogDelivery" fix
        funct_verbose_message "cd aws ; aws s3api put-bucket-logging --region $aws_region --bucket $bucket --bucket-logging-status file://server-access-logging.json"
        funct_verbose_message "" fix
      else
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail log file bucket $bucket has access logging enabled [$secure Passes]"
      fi
      total=`expr $total + 1`
      check=`aws s3api get-bucket-versioning --bucket $bucket |grep Enabled`
      if [ "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail log bucket $bucket has versioning enabled [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail bucket $bucket does not have versioning enabled [$insecure Warnings]"
      fi
    done
    trails=`aws cloudtrail describe-trails --region $aws_region --query trailList[].Name --output text`
    for trail in $trails; do
      # Check CloudTrail has a CloudWatch Logs group enabled
      total=`expr $total + 1`
      check=`aws cloudtrail describe-trails --region $aws_region --trail-name-list $trail |grep CloudWatchLogsLogGroupArn`
      if [ ! "$check" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail $trail does not have a CloudWatch Logs group enabled [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail $trail has a CloudWatch Logs group enabled [$secure Passes]"
      fi
      # Check CloudTrail bucket is receiving logs
      total=`expr $total + 1`
      check=`aws cloudtrail get-trail-status --region $aws_region --name $bucket --query "LatestCloudWatchLogsDeliveryTime" --output text`
      if [ ! "$check" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail $trail does not have a Last log file delivered timestamp [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail $trail has a last log file delivered timestamp [$secure Passes]"
      fi
      # Check CloudTrail has key enabled for bucket
      total=`expr $total + 1`
      check=`aws cloudtrail get-trail-status --region $aws_region --name $bucket| grep KmsKeyId`
      if [ ! "$check" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudTrail $trail does not have a KMS Key ID [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    CloudTrail $trail has a KMS Key ID [$secure Passes]"
      fi
    done
  else
    total=`expr $total + 1`
    secure=`expr $secure + 1`
    echo "Warning:   CloudTrail is not enabled [$secure Passes]"
  fi
}

