# audit_aws_rec_ec2
#
# Ensure that all your Amazon Machine Images (AMIs) are using suitable naming
# conventions for tagging in order to manage them more efficiently and adhere
# to AWS resource tagging best practices. A naming convention is a well-defined
# set of rules useful for choosing the name of an AWS resource.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/ami-naming-conventions.html
#
# Ensure that all the AWS EC2 instances necessary for your application stack are
# launched from your approved base Amazon Machine Images (AMIs), known as golden
# AMIs in order to enforce consistency and save time when scaling your
# application.
#
# An approved/golden AMI is a base EC2 machine image that contains a
# pre-configured OS and a well-defined stack of server software fully configured
# to run your application. Using golden AMIs to create new EC2 instances within
# your AWS environment brings major benefits such as fast and stable application
# deployment and scaling, secure application stack upgrades and versioning.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/approved-golden-amis.html
#
# Ensure that all your EC2 instances are using suitable naming conventions for
# tagging in order to manage them more efficiently and adhere to AWS resource
# tagging best practices. A naming convention is an established set of rules
# useful for choosing the name of an AWS resource
#
# Naming (tagging) your EC2 instances logically and consistently has several
# advantages such as providing additional information about the instance
# location and usage, promoting consistency within the selected environment,
# distinguishing fast similar resources from one another, improving clarity
# in cases of potential ambiguity and classifying them accurately as compute
# resources for easy management and billing purposes.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/ec2-instance-naming-conventions.html
#.

audit_aws_rec_ec2 () {
  images=`aws ec2 describe-images --region $aws_region --owners self --query "Images[].ImageId" --output text`
  for image in $images; do
    total=`expr $total + 1`
	  name=`aws ec2 describe-images --region $aws_region --owners self --image-id $image --query "Images[].Tags[?Key==\\\`Name\\\`].Value" --output text`
    if [ ! "$name" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   AWS AMI $image does not have a Name tag [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws ec2 create-tags --region $aws_region --resources $image --tags Key=Name,Value=<valid_name_tag>" fix
      funct_verbose_message "" fix
    else
      check=`echo $name |grep "$valid_host_grep"`
      if [ "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    AWS AMI $image has a valid Name tag [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   AWS AMI $image does not have a valid Name tag [$insecure Warnings]"
      fi
    fi
  done
  instances=`aws ec2 describe-instances --region $aws_region --query "Reservations[].Instances[].InstanceId" --output text`
  for instance in $instances; do
    total=`expr $total + 1`
    name=`aws ec2 describe-instances --region $aws_region --instance-id $instance --query "Reservations[].Instances[].Tags[?Key==\\\`Name\\\`].Value" --output text`
    if [ ! "$name" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   AWS AMI $image does not have a Name tag [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws ec2 create-tags --region $aws_region --resources $instances --tags Key=Name,Value=<valid_name_tag>" fix
      funct_verbose_message "" fix
    else
      check=`echo $name |grep "$valid_host_grep"`
      if [ "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    AWS Instance $instance has a valid Name tag [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   AWS Instance $instance does not have a valid Name tag [$insecure Warnings]"
      fi
    fi
  done
  images=`aws ec2 describe-instances --region $aws_region --query 'Reservations[].Instances[].ImageId' --output text`
  for image in $images; do
    total=`expr $total + 1`
    owner=`aws ec2 describe-images --region $aws_region --image-ids $image --query 'Images[].ImageOwnerAlias' --output text`
    if [ "$owner" = "self" ] || [ ! "$owner" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    AWS AMI $image is a self produced image [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   AWS AMI $image is not have a valid Name tag [$insecure Warnings]"
    fi
  done
  total=`expr $total + 1`
  max_ips=`aws ec2 describe-account-attributes --region $aws_region --attribute-names max-elastic-ips --query "AccountAttributes[].AttributeValues[].AttributeValue" --output text`
  no_ips=`aws ec2 describe-addresses --region $aws_region --query 'Addresses[].PublicIp' --filters "Name=domain,Values=standard" --output text |wc -l`
  if [ "$max_ips" -ne  "$no_ips" ]; then
    secure=`expr $secure + 1`
    echo "Secure:    Number of Elastic IPs consumed is less than limit of $max_ips [$secure Passes]"
  else
    insecure=`expr $insecure + 1`
    echo "Warning:   Number of Elastic IPs consumed has reached limit of $max_ips [$insecure Warnings]"
  fi
  instances=`aws ec2 describe-instances --region $aws_region --query 'Reservations[*].Instances[*].InstanceId' --output text`
  for instance in $instances; do
    total=`expr $total + 1`
    vpc_id=`aws ec2 describe-instances --region $aws_region --instance-ids $instance --query 'Reservations[*].Instances[*].VpcId' --output text`
    if [ "$vpc_id" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Instance $instance is an EC2-VPC platform [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Instance $instance is an EC2-Classic platform [$insecure Warnings]"
    fi 
  done
}

