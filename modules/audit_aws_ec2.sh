# audit_aws_ec2
#
# Ensure that the EC2 instances provisioned in your AWS account are not
# associated with default security groups created alongside with your VPCs in
# order to enforce using custom and unique security groups that exercise the
# principle of least privilege.
#
# When an EC2 instance is launched without specifying a custom security group,
# the default security group is automatically assigned to the instance.
# Because a lot of instances are launched in this way, if the default security
# group is configured to allow unrestricted access, it can increase
# opportunities for malicious activity such as hacking, brute-force attacks or
# even denial-of-service (DoS) attacks.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/default-securitygroups-in-use.html
#
# Use IAM Roles/Instance Profiles instead of IAM Access Keys to appropriately
# grant access permissions to any application that perform AWS API requests
# running on your EC2 instances. With IAM roles you can avoid sharing long-term
# credentials and protect your instances against unauthorized access.
#
# Using IAM Roles over IAM Access Keys to sign AWS API requests has multiple
# benefits. For example, once enabled, you or your administrators don't have
# to manage credentials anymore as the credentials provided by the IAM roles
# are temporary and rotated automatically behind the scenes. You can use a
# single role for multiple EC2 instances within your stack, manage its access
# policies in one place and allow these to propagate automatically to all
# instances. Also, you can easily restrict which role a IAM user can assign
# to an EC2 instance during the launch process in order to stop the user from
# trying to gain elevated (overly permissive) privileges.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/ec2-instance-using-iam-roles.html
#
# Ensure that your AWS AMIs are not publicly shared with the other AWS accounts
# in order to avoid exposing sensitive data. It is strongly recommended against
# sharing your AMIs with all AWS accounts. If required, you can share your
# images with specific AWS accounts without making them public.
#
# When you make your AMIs publicly accessible, these become available in the
# Community AMIs where everyone with an AWS account can use them to launch
# EC2 instances. Most of the time your AMIs will contain snapshots of your
# applications (including their data), therefore exposing your snapshots in
# this manner is not advised.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/publicly-shared-ami.html
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
      funct_verbose_message "" fix
      funct_verbose_message "aws ec2 modify-image-attribute --region $aws_region --image-id $image --launch-permission '{\"Remove\":[{\"Group\":\"all\"}]}'" fix
      funct_verbose_message "" fix
    fi
  done
}

