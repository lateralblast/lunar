# audit_aws_ec2
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/default-securitygroups-in-use.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/ec2-instance-using-iam-roles.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/publicly-shared-ami.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/ebs-encrypted.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/ebs-encrypted-with-kms-customer-master-keys.html
#.

audit_aws_ec2 () {
  instances=`aws ec2 describe-instances --region $aws_region --query 'Reservations[].Instances[].InstanceId' --filters "Name=instance.group-name,Values=default" --output text`
  if [ ! "$instances" ]; then
    total=`expr $total + 1`
    secure=`expr $secure + 1`
    echo "Secure:    There are no instances using the default security group [$secure Passes]"
  else
    for instance in $instances; do
      total=`expr $total + 1`
      insecure=`expr $insecure + 1`
      echo "Warning:   The instance $instance is using the default security group [$insecure Warnings]"
    done
  fi
  instances=`aws ec2 describe-instances --region $aws_region --query "Reservations[].Instances[].InstanceId" --output text`
  for instance in $instances; do
    total=`expr $total + 1`
    profile=`aws ec2 describe-instances --region $aws_region --instance-ids $instance --query "Reservations[*].Instances[*].IamInstanceProfile" --output text`
    if [ "$profile" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Instances $instance uses an IAM profile [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Instance $instance does not us an IAM profile [$insecure Warnings]"
    fi
  done
  images=`aws ec2 describe-images --region $aws_region --owners self --query "Images[].ImageId" --output text`
  for image in $images; do
    public=`aws ec2 describe-images --owners self --region $aws_region --image-ids $image --query "Images[].Public" |grep true`
    if [ ! "$public" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Image $image is not publicly shared [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Image $image is publicly shared [$insecure Warnings]"
      verbose_message "" fix
      verbose_message "aws ec2 modify-image-attribute --region $aws_region --image-id $image --launch-permission '{\"Remove\":[{\"Group\":\"all\"}]}'" fix
      verbose_message "" fix
    fi
  done
  volumes=`aws ec2 describe-volumes --query "Volumes[].VolumeId" --output text`
  for volume in $volumes; do
    total=`expr $total + 1`
    check=`aws ec2 describe-volumes --volume-id vol-09c7933ad01825300 --query "Volumes[].Encrypted" |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    EBS Volume $volume is encrypted [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   EBS Volume $volume is not encrypted [$insecure Warnings]"
    fi
    # Check if KMS is being used
    total=`expr $total + 1`
    key_id=`aws ec2 describe-volumes --region $aws_region --volume-ids $volume --query 'Volumes[].KmsKeyId' --output text |cut -f2 -d/`
    if [ "$key_id" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    EBS Volume $volume is encrypted with a KMS key [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   EBS Volume $volume is encrypted with a KMS key [$insecure Warnings]"
    fi
  done
}

