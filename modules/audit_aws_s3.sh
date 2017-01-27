# audit_aws_s3
#
# Ensure that your AWS S3 buckets are not granting FULL_CONTROL access to
# authenticated users (i.e. signed AWS accounts or AWS IAM users) in order to
# prevent unauthorized access. An S3 bucket that allows full control access to
# authenticated users will give any AWS account or IAM user the ability to LIST
# (READ) objects, UPLOAD/DELETE (WRITE) objects, VIEW (READ_ACP) objects
# permissions and EDIT (WRITE_ACP) permissions for the objects within the bucket.
# Cloud Conformity strongly recommends against setting all these permissions for
# the 'Any Authenticated AWS User' ACL predefined group in production.
#
# Granting authenticated "FULL_CONTROL" access to AWS S3 buckets can allow other
# AWS accounts or IAM users to view, upload, modify and delete S3 objects
# without any restrictions. Exposing your S3 buckets to AWS signed accounts or
# users can lead to data leaks, data loss and unexpected charges for the S3
# service.
#
# Refer to https://www.cloudconformity.com/conformity-rules/S3/s3-bucket-authenticated-users-full-control-access.html
#
# Ensure that AWS S3 Server Access Logging feature is enabled in order to record
# access requests useful for security audits. By default, server access logging
# is not enabled for S3 buckets.
#
# With Server Access Logging feature enabled for your S3 buckets you can track
# any requests made to access the buckets and use the log data to take measures
# in order to protect them against unauthorized user access.
#
# Refer to https://www.cloudconformity.com/conformity-rules/S3/s3-bucket-logging-enabled.html
#
# Ensure there aren't any publicly accessible S3 buckets available in your AWS
# account in order to protect your S3 data from loss and unauthorized access.
# A publicly accessible S3 bucket allows FULL_CONTROL access to everyone
# (i.e. anonymous users) to LIST (READ) the objects within the bucket,
# UPLOAD/DELETE (WRITE) objects, VIEW (READ_ACP) object permissions and
# EDIT (WRITE_ACP) object permissions. Cloud Conformity strongly recommends
# against using all these permissions for the “Everyone” ACL predefined group
# in production.
#
# Refer to https://www.cloudconformity.com/conformity-rules/S3/s3-bucket-public-full-control-access.html
#.

audit_aws_s3 () {
  buckets=`aws s3api list-buckets --region $aws_region --query 'Buckets[*].Name' --output text`
  for bucket in $buckets; do
    for user in http://acs.amazonaws.com/groups/global/AllUsers http://acs.amazonaws.com/groups/global/AuthenticatedUsers; do
      total=`expr $total + 1`
      grants=`aws s3api get-bucket-acl --region $aws_region --bucket $bucket |grep URI |grep "$user"`
      if [ "$grants" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Bucket $bucket grants access to Principal $user [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    Bucket $bucket does not grant access to Principal $user [$secure Passes]"
      fi
    done
    total=`expr $total + 1`
    logging=`aws s3api get-bucket-logging --region $aws_region --bucket $bucket`
    if [ ! "$logging" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   Bucket $bucket does not have access logging enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws s3api put-bucket-acl --region $aws_region --bucket $bucket --grant-write URI=http://acs.amazonaws.com/groups/s3/LogDelivery --grant-read-acp URI=http://acs.amazonaws.com/groups/s3/LogDelivery" fix
      funct_verbose_message "cd aws ; aws s3api put-bucket-logging --region $aws_region --bucket $bucket --bucket-logging-status file://server-access-logging.json"
      funct_verbose_message "" fix
    else
      secure=`expr $secure + 1`
      echo "Secure:    Bucket $bucket has access logging enabled [$secure Passes]"
    fi
    total=`expr $total + 1`
    check=`aws s3api get-bucket-versioning --bucket $bucket |grep Enabled`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Bucket $bucket has versioning enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Bucket $bucket does not have versioning enabled [$insecure Warnings]"
    fi
  done
}

