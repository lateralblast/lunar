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
  done
}

