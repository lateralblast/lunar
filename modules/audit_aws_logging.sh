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
  verbose_message "CloudTrail"
  trails=$( aws cloudtrail describe-trails --region $aws_region --query "trailList[].Name" --output text )
  if [ "$trails" ]; then
    for trail in $trails; do
      # Check CloudTrail has MultiRegion enabled
      check=$( aws cloudtrail describe-trails --region $aws_region --trail-name-list $trail --query "trailList[].IsMultiRegionTrail" | grep true )
      if [ "$check" ]; then
        increment_secure "CloudTrail $trail is enabled in all regions"
    	else
        increment_insecure "CloudTrail $trail is not enabled in all regions"
        verbose_message "" fix
        verbose_message "aws cloudtrail update-trail --name $trail --is-multi-region-trail" fix
        verbose_message "" fix
      fi
      # Check CloudTrail is recording global events
      check=$( aws cloudtrail describe-trails --region $aws_region --trail-name-list $trail --query "trailList[].IncludeGlobalServiceEvents" | grep true )
      if [ "$check" ]; then
        increment_secure "CloudTrail $trail is recording global events"
      else
        increment_insecure "CloudTrail $trail is not recording global events"
        verbose_message "" fix
        verbose_message "aws cloudtrail update-trail --name $trail --include-global-service-events" fix
        verbose_message "" fix
      fi
      # Check log file validation is enabled
      check=$( aws cloudtrail describe-trails --region $aws_region --trail-name-list $trail --query "trailList[].LogFileValidationEnabled" | grep true )
      if [ "$check" ]; then
        increment_secure "CloudTrail $trail log file validation is enabled"
      else
        increment_insecure "CloudTrail $trail log file validation is not enabled"
        verbose_message "" fix
        verbose_message "aws cloudtrail update-trail --region $aws_region --name $trail --enable-log-file-validation" fix
        verbose_message "" fix
      fi
      # 
    done
    buckets=$( aws cloudtrail describe-trails --region $aws_region --query 'trailList[*].S3BucketName' --output text )
    # Check that CloudTrail buckets don't grant access to users it shouldn't
    # Check that CloudTrail bucket versioning is enable
    for bucket in $buckets; do
      grants=$( aws s3api get-bucket-acl --region $aws_region --bucket $bucket | grep URI | grep AllUsers )
      if [ "$grants" ]; then
        increment_insecure "CloudTrail log file bucket $bucket grants access to Principal AllUsers"
      else
        increment_secure "CloudTrail log file bucket $bucket does not grant access to Principal AllUsers"
      fi
      grants=$( aws s3api get-bucket-acl --region $aws_region --bucket $bucket | grep URI | grep AuthenticatedUsers )
      if [ "$grants" ]; then
        increment_insecure "CloudTrail log file bucket $bucket grants access to Principal AuthenticatedUsers"
        verbose_message "" fix
        verbose_message "aws s3api put-bucket-acl --region $aws_region --region $aws_region--bucket $bucket --acl private" fix
        verbose_message "" fix
      else
        increment_secure "CloudTrail log file bucket $bucket does not grant access to Principal AuthenticatedUsers"
      fi
      
      grants=$( aws s3api get-bucket-policy --region $aws_region --bucket $bucket --query Policy | tr "}" "\n" | grep Allow | grep "*" )
      if [ "$grants" ]; then
        increment_insecure "CloudTrail log file bucket $bucket grants access to Principal *"
      else
        increment_secure "CloudTrail log file bucket $bucket does not grant access to Principal *"
      fi
      logging=$( aws s3api get-bucket-logging --region $aws_region --bucket $bucket )
      if [ ! "$logging" ]; then
        increment_insecure "CloudTrail log file bucket $bucket does not have access logging enabled"
        verbose_message "" fix
        verbose_message "aws s3api put-bucket-acl --region $aws_region --bucket $bucket --grant-write URI=http://acs.amazonaws.com/groups/s3/LogDelivery --grant-read-acp URI=http://acs.amazonaws.com/groups/s3/LogDelivery" fix
        verbose_message "cd aws ; aws s3api put-bucket-logging --region $aws_region --bucket $bucket --bucket-logging-status file://server-access-logging.json"
        verbose_message "" fix
      else
        increment_secure "CloudTrail log file bucket $bucket has access logging enabled"
      fi
      check=$( aws s3api get-bucket-versioning --bucket $bucket | grep Enabled )
      if [ "$check" ]; then
        increment_secure "CloudTrail log bucket $bucket has versioning enabled"
      else
        increment_insecure "CloudTrail bucket $bucket does not have versioning enabled"
      fi
    done
    trails=$( aws cloudtrail describe-trails --region $aws_region --query trailList[].Name --output text )
    for trail in $trails; do
      # Check CloudTrail has a CloudWatch Logs group enabled
      check=$( aws cloudtrail describe-trails --region $aws_region --trail-name-list $trail |grep CloudWatchLogsLogGroupArn )
      if [ ! "$check" ]; then
        increment_insecure "CloudTrail $trail does not have a CloudWatch Logs group enabled"
      else
        increment_secure "CloudTrail $trail has a CloudWatch Logs group enabled"
      fi
      # Check CloudTrail bucket is receiving logs
      check=$( aws cloudtrail get-trail-status --region $aws_region --name $bucket --query "LatestCloudWatchLogsDeliveryTime" --output text )
      if [ ! "$check" ]; then
        increment_insecure "CloudTrail $trail does not have a Last log file delivered timestamp"
      else
        increment_secure "CloudTrail $trail has a last log file delivered timestamp"
      fi
      # Check CloudTrail has key enabled for bucket
      check=$( aws cloudtrail get-trail-status --region $aws_region --name $bucket | grep KmsKeyId )
      if [ ! "$check" ]; then
        increment_insecure "CloudTrail $trail does not have a KMS Key ID"
      else
        increment_secure "CloudTrail $trail has a KMS Key ID"
      fi
    done
  else
    increment_insecure "CloudTrail is not enabled"
  fi
}

