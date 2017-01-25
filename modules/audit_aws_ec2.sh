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
#.

audit_aws_ec2 () {
  instances=`aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --filters "Name=instance.group-name,Values=default" --output text`
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
}

