# audit_aws_s3
#
# Refer to https://www.cloudconformity.com/conformity-rules/S3/s3-bucket-authenticated-users-full-control-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/S3/s3-bucket-logging-enabled.html
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
      verbose_message "" fix
      verbose_message "aws s3api put-bucket-acl --region $aws_region --bucket $bucket --grant-write URI=http://acs.amazonaws.com/groups/s3/LogDelivery --grant-read-acp URI=http://acs.amazonaws.com/groups/s3/LogDelivery" fix
      verbose_message "cd aws ; aws s3api put-bucket-logging --region $aws_region --bucket $bucket --bucket-logging-status file://server-access-logging.json"
      verbose_message "" fix
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

