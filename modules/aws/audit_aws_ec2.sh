#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_ec2
#
# Check AWS EC2
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/default-securitygroups-in-use.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/ec2-instance-using-iam-roles.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/publicly-shared-ami.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/ebs-encrypted.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/ebs-encrypted-with-kms-customer-master-keys.html
#.

audit_aws_ec2 () {
  print_function  "audit_aws_ec2"
  verbose_message "EC2"   "check"
  command="aws ec2 describe-instances --region \"${aws_region}\" --query 'Reservations[].Instances[].InstanceId' --filters \"Name=instance.group-name,Values=default\" --output text"
  command_message "${command}"
  instances=$( eval "${command}" )
  if [ -z "${instances}" ]; then
    increment_secure "There are no instances using the default security group"
  else
    for instance in ${instances}; do
      increment_insecure "The instance \"${instance}\" is using the default security group"
    done
  fi
  command="aws ec2 describe-instances --region \"${aws_region}\" --query \"Reservations[].Instances[].InstanceId\" --output text"
  command_message "${command}"
  instances=$( eval "${command}" )
  for instance in ${instances}; do
    command="aws ec2 describe-instances --region \"${aws_region}\" --instance-ids \"${instance}\" --query \"Reservations[*].Instances[*].IamInstanceProfile\" --output text"
    command_message "${command}"
    profile=$( eval "${command}" )
    if [ -n "${profile}" ]; then
      increment_secure   "Instances \"${instance}\" uses an IAM profile"
    else
      increment_insecure "Warning:   Instance \"${instance}\" does not use an IAM profile"
    fi
  done
  command="aws ec2 describe-images --region \"${aws_region}\" --owners self --query \"Images[].ImageId\" --output text"
  command_message "${command}"
  images=$( eval "${command}" )
  for image in ${images}; do
    command="aws ec2 describe-images --owners self --region \"${aws_region}\" --image-ids \"${image}\" --query \"Images[].Public\" | grep true"
    command_message "${command}"
    public=$( eval "${command}" )
    if [ -z "${public}" ]; then
      increment_secure   "Image \"${image}\" is not publicly shared"
    else
      increment_insecure "Image \"${image}\" is publicly shared"
      verbose_message    "aws ec2 modify-image-attribute --region ${aws_region} --image-id ${image} --launch-permission '{\"Remove\":[{\"Group\":\"all\"}]}'" "fix"
    fi
  done
  command="aws ec2 describe-volumes --query \"Volumes[].VolumeId\" --output text"
  command_message "${command}"
  volumes=$( eval "${command}" )
  for volume in ${volumes}; do
    command="aws ec2 describe-volumes --volume-id \"${volume}\" --query \"Volumes[].Encrypted\" | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure   "EBS Volume \"${volume}\" is encrypted"
    else
      increment_insecure "EBS Volume \"${volume}\" is not encrypted"
    fi
    # Check if KMS is being used
    command="aws ec2 describe-volumes --region \"${aws_region}\" --volume-ids \"${volume}\" --query 'Volumes[].KmsKeyId' --output text | cut -f2 -d/"
    command_message "${command}"
    key_id=$( eval "${command}" )
    if [ -n "${key_id}" ]; then
      increment_secure   "EBS Volume \"${volume}\" is encrypted with a KMS key"
    else
      increment_insecure "EBS Volume \"${volume}\" is encrypted not with a KMS key"
    fi
  done
}

