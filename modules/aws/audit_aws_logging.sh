#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_logging
#
# Check AWS Logging
#
# Refer to Section(s) 2.1 Page(s) 70-1 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.2 Page(s) 72-3 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.3 Page(s) 74-5 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.4 Page(s) 76-7 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.6 Page(s) 81-2 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 2.7 Page(s) 83-4 CIS AWS Foundations Benchmark v1.1.0
#
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
  print_function  "audit_aws_logging"
  verbose_message "CloudTrail" "check"
  command="aws cloudtrail describe-trails --region \"${aws_region}\" --query \"trailList[].Name\" --output text"
  command_message "${command}"
  trails=$( eval "${command}" )
  if [ "${trails}" ]; then
    for trail in ${trails}; do
      # Check CloudTrail has MultiRegion enabled
      command="aws cloudtrail describe-trails --region \"${aws_region}\" --trail-name-list \"${trail}\" --query \"trailList[].IsMultiRegionTrail\" | grep true"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -n "${check}" ]; then
        increment_secure   "CloudTrail \"${trail}\" is enabled in all regions"
    	else
        increment_insecure "CloudTrail \"${trail}\" is not enabled in all regions"
        verbose_message    "aws cloudtrail update-trail --name ${trail} --is-multi-region-trail" fix
      fi
      # Check CloudTrail is recording global events
      command="aws cloudtrail describe-trails --region \"${aws_region}\" --trail-name-list \"${trail}\" --query \"trailList[].IncludeGlobalServiceEvents\" | grep true"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -n "${check}" ]; then
        increment_secure   "CloudTrail \"${trail}\" is recording global events"
      else
        increment_insecure "CloudTrail \"${trail}\" is not recording global events"
        verbose_message    "aws cloudtrail update-trail --name ${trail} --include-global-service-events" fix
      fi
      # Check log file validation is enabled
      command="aws cloudtrail describe-trails --region \"${aws_region}\" --trail-name-list \"${trail}\" --query \"trailList[].LogFileValidationEnabled\" | grep true"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -n "${check}" ]; then
        increment_secure   "CloudTrail \"${trail}\" log file validation is enabled"
      else
        increment_insecure "CloudTrail \"${trail}\" log file validation is not enabled"
        verbose_message    "aws cloudtrail update-trail --region ${aws_region} --name ${trail} --enable-log-file-validation" fix
      fi
      # 
    done
    command="aws cloudtrail describe-trails --region \"${aws_region}\" --query 'trailList[*].S3BucketName' --output text"
    command_message "${command}"
    buckets=$( eval "${command}" )
    # Check that CloudTrail buckets don't grant access to users it shouldn't
    # Check that CloudTrail bucket versioning is enable
    for bucket in ${buckets}; do
      command="aws s3api get-bucket-acl --region \"${aws_region}\" --bucket \"${bucket}\" | grep URI | grep AllUsers"
      command_message "${command}"
      grants=$( eval "${command}" )
      if [ -n "${grants}" ]; then
        increment_insecure "CloudTrail log file bucket \"${bucket}\" grants access to Principal AllUsers"
      else
        increment_secure   "CloudTrail log file bucket \"${bucket}\" does not grant access to Principal AllUsers"
      fi
      command="aws s3api get-bucket-acl --region \"${aws_region}\" --bucket \"${bucket}\" | grep URI | grep AuthenticatedUsers"
      command_message "${command}"
      grants=$( eval "${command}" )
      if [ -n "${grants}" ]; then
        increment_insecure "CloudTrail log file bucket ${bucket} grants access to Principal AuthenticatedUsers"
        verbose_message    "aws s3api put-bucket-acl --region ${aws_region} --region ${aws_region}--bucket ${bucket} --acl private" fix
      else
        increment_secure   "CloudTrail log file bucket ${bucket} does not grant access to Principal AuthenticatedUsers"
      fi
      
      command="aws s3api get-bucket-policy --region \"${aws_region}\" --bucket \"${bucket}\" --query Policy | tr \"}\" \"\\\n\" | grep Allow | grep \"\*\""
      command_message "${command}"
      grants=$( eval "${command}" )
      if [ -n "${grants}" ]; then
        increment_insecure "CloudTrail log file bucket \"${bucket}\" grants access to Principal *"
      else
        increment_secure   "CloudTrail log file bucket \"${bucket}\" does not grant access to Principal *"
      fi
      command="aws s3api get-bucket-logging --region \"${aws_region}\" --bucket \"${bucket}\""
      command_message "${command}"
      logging=$( eval "${command}" )
      if [ -z "$logging" ]; then
        increment_insecure "CloudTrail log file bucket ${bucket} does not have access logging enabled"
        verbose_message    "aws s3api put-bucket-acl --region ${aws_region} --bucket ${bucket} --grant-write URI=http://acs.amazonaws.com/groups/s3/LogDelivery --grant-read-acp URI=http://acs.amazonaws.com/groups/s3/LogDelivery" fix
        verbose_message    "cd aws ; aws s3api put-bucket-logging --region ${aws_region} --bucket ${bucket} --bucket-logging-status file://server-access-logging.json"
      else
        increment_secure   "CloudTrail log file bucket ${bucket} has access logging enabled"
      fi
      command="aws s3api get-bucket-versioning --bucket \"${bucket}\" | grep Enabled"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -n "${check}" ]; then
        increment_secure   "CloudTrail log bucket \"${bucket}\" has versioning enabled"
      else
        increment_insecure "CloudTrail bucket \"${bucket}\" does not have versioning enabled"
      fi
    done
    command="aws cloudtrail describe-trails --region \"${aws_region}\" --query trailList[].Name --output text"
    command_message "${command}"
    trails=$( eval "${command}" )
    for trail in ${trails}; do
      # Check CloudTrail has a CloudWatch Logs group enabled
      command="aws cloudtrail describe-trails --region \"${aws_region}\" --trail-name-list \"${trail}\" |grep CloudWatchLogsLogGroupArn"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -z "${check}" ]; then
        increment_insecure "CloudTrail ${trail} does not have a CloudWatch Logs group enabled"
      else
        increment_secure   "CloudTrail ${trail} has a CloudWatch Logs group enabled"
      fi
      # Check CloudTrail bucket is receiving logs
      command="aws cloudtrail get-trail-status --region \"${aws_region}\" --name \"${bucket}\" --query \"LatestCloudWatchLogsDeliveryTime\" --output text"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -z "${check}" ]; then
        increment_insecure "CloudTrail \"${trail}\" does not have a Last log file delivered timestamp"
      else
        increment_secure   "CloudTrail \"${trail}\" has a last log file delivered timestamp"
      fi
      # Check CloudTrail has key enabled for bucket
      command="aws cloudtrail get-trail-status --region \"${aws_region}\" --name \"${bucket}\" | grep KmsKeyId"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -z "${check}" ]; then
        increment_insecure "CloudTrail \"${trail}\" does not have a KMS Key ID"
      else
        increment_secure   "CloudTrail \"${trail}\" has a KMS Key ID"
      fi
    done
  else
    increment_insecure "CloudTrail is not enabled"
  fi
}

