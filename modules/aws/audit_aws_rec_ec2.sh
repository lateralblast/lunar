#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_rec_ec2
#
# Check EC2 Recommendations
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/ami-naming-conventions.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/approved-golden-amis.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/ec2-instance-naming-conventions.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/ec2-instance-termination-protection.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/security-group-naming-conventions.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/ebs-naming-conventions.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/general-purpose-ssd-volume.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/ebs-volumes-too-old-snapshots.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/unused-ebs-volumes.html
# Refer to https://www.cloudconformity.com/conformity-rules/EBS/ebs-volumes-recent-snapshots.html
#.

audit_aws_rec_ec2 () {
  print_function  "audit_aws_rec_ec2"
  verbose_message "EC2 Recommendations" "check"
  command="aws ec2 describe-volumes --region \"${aws_region}\" --query 'Volumes[].VolumeId' --output text"
  command_message "${command}"
  volumes=$( eval "${command}" )
  for volume in ${volumes}; do
    if [ "${check_volattach}" = "y" ]; then
      # Check for EC2 volumes that are unattached
      command="aws ec2 describe-volumes --region \"${aws_region}\" --volume-id \"${volume}\" --query 'Volumes[].State' --output text"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ ! "${check}" = "available" ]; then
        increment_secure   "EC2 volume \"${volume}\" is attached to an instance"
      else
        increment_insecure "EC2 volume \"${volume}\" is not attached to an instance"
      fi
    fi
    if [ "${check_volattach}" = "y" ]; then
      # Check that EC2 volumes are using cost effective storage
      command="aws ec2 describe-volumes --region \"${aws_region}\" --volume-id \"${volume}\" --query 'Volumes[].VolumeType' | grep \"gp2\""
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -n "${check}" ]; then
        increment_secure   "EC2 volume \"${volume}\" is using General Purpose SSD"
      else
        increment_insecure "EC2 volume \"${volume}\" is not using General Purpose SSD"
      fi
    fi
  done
  # Check date of snapshots
  if [ "${check_snapage}" = "y" ]; then
    command="aws iam get-user --query \"User.Arn\" --output text | cut -f5 -d:"
    command_message "${command}"
    arn=$( eval "${command}" )
    command="aws ec2 describe-snapshots --region \"${aws_region}\" --owner-ids \"${arn}\" --filters ansible_value=status,Values=completed --query \"Snapshots[].SnapshotId\" --output text"
    command_message "${command}"
    snapshots=$( eval "${command}" )
    counter=0
    for snapshot in ${snapshot}s; do
      command="aws ec2 describe-snapshots --region \"${aws_region}\" --snapshot-id \"${snapshot}\" --query \"Snapshots[].StartTime\" --output text --output text | cut -f1 -d."
      command_message "${command}"
      snap_date=$( eval "${command}" )
      if [ "${os_name}" = "Linux" ]; then
        command="date -d \"${snap_date}\" \"+%s\""
        command_message "${command}"
        snap_secs=$( eval "${command}" )
      else
        command="date -j -f \"%Y-%m-%dT%H:%M:%SS\" \"${snap_date}\" \"+%s\""
        command_message "${command}"
        snap_secs=$( eval "${command}" )
      fi
      command="date \"+%s\""
      command_message "${command}"
      curr_secs=$( eval "${command}" )
      command="echo \"(${curr_secs} - ${snap_secs})/84600\" | bc"
      command_message "${command}"
      diff_days=$( eval "${command}" )
      if [ "${diff_days}" -gt "${aws_ec2_max_retention}" ]; then
        increment_insecure "EC2 snapshot \"${snapshot}\" is more than \"${aws_ec2_max_retention}\" days old"
      else
        increment_secure   "EC2 snapshot \"${snapshot}\" is less than \"${aws_ec2_max_retention}\" days old"
      fi
      if [ "${diff_days}" -gt "${aws_ec2_min_retention}" ]; then
        counter=$((counter+1))
      fi
    done
    if [ "${counter}" -gt 0 ]; then
      increment_secure   "There are EC2 snapshots more than \"${aws_ec2_min_retention}\" days old"
    else
      increment_insecure "There are no EC2 snapshots more than \"${aws_ec2_min_retention}\" days old"
    fi
  fi
  # Check Security Groups have Name tags
  command="aws ec2 describe-security-groups --region \"${aws_region}\" --query 'SecurityGroups[].GroupId' --output text"
  command_message "${command}"
  sgs=$( eval "${command}" )
  for sg in ${sgs}; do
    if [ ! "${sg}" = "default" ]; then
      command="aws ec2 describe-security-groups --region \"${aws_region}\" --group-id \"${sg}\" --query \"SecurityGroups[].Tags[?Key==\\\`Name\\\`].Value\" 2> /dev/null --output text"
      command_message "${command}"
      ansible_value=$( eval "${command}" )
      if [ -z "${ansible_value}" ]; then
        increment_insecure "AWS Security Group \"${sg}\" does not have a Name tag"
        verbose_message    "aws ec2 create-tags --region \"${aws_region}\" --resources \"${image}\" --tags Key=Name,Value=<valid_name_tag>" "fix"
      else
        if [ "${strict_valid_names}" = "y" ]; then
          command="echo \"${ansible_value}\" |grep \"^sg-${valid_tag_string}\""
          command_message "${command}"
          check=$( eval "${command}" )
          if [ -n "${check}" ]; then
            increment_secure   "AWS Security Group \"${sg}\" has a valid Name tag"
          else
            increment_insecure "AWS Security Group \"${sg}\" does not have a valid Name tag"
          fi
        fi
      fi
    fi
  done
  # Check Volumes have Name tags
  command="aws ec2 describe-volumes --region \"${aws_region}\" --query \"Volumes[].VolumeId\" --output text"
  command_message "${command}"
  volumes=$( eval "${command}" )
  for volume in ${volumes}; do
    command="aws ec2 describe-volumes --region \"${aws_region}\" --volume-id \"${volume}\" --query \"Volumes[].Tags[?Key==\\\`Name\\\`].Value\" --output text"
    command_message "${command}"
    ansible_value=$( eval "${command}" )
    if [ -z "${ansible_value}" ]; then
      increment_insecure "AWS EC2 volume \"${volume}\" does not have a Name tag"
      verbose_message    "aws ec2 create-tags --region \"${aws_region}\" --resources \"${volume}\" --tags Key=Name,Value=<valid_name_tag>" "fix"
    else
      if [ "${strict_valid_names}" = "y" ]; then
        command="echo \"${ansible_value}\" |grep \"^ami-${valid_tag_string}\""
        command_message "${command}"
        check=$( eval "${command}" )
        if [ -n "${check}" ]; then
          increment_secure   "AWS EC2 volume \"${volume}\" has a valid Name tag"
        else
          increment_insecure "AWS EC2 volume \"${volume}\" does not have a valid Name tag"
        fi
      fi
    fi
  done
  # Check AMIs have Name tags
  command="aws ec2 describe-images --region \"${aws_region}\" --owners self --query \"Images[].ImageId\" --output text"
  command_message "${command}"
  images=$( eval "${command}" )
  for image in ${images}; do
	  command="aws ec2 describe-images --region \"${aws_region}\" --owners self --image-id \"${image}\" --query \"Images[].Tags[?Key==\\\`Name\\\`].Value\" --output text"
    command_message "${command}"
    ansible_value=$( eval "${command}" )
    if [ -z "${ansible_value}" ]; then
      increment_insecure "AWS AMI \"${image}\" does not have a Name tag"
      verbose_message    "aws ec2 create-tags --region \"${aws_region}\" --resources \"${image}\" --tags Key=Name,Value=<valid_name_tag>" "fix"
    else
      if [ "${strict_valid_names}" = "y" ]; then
        command="echo \"${ansible_value}\" |grep \"^ami-${valid_tag_string}\""
        command_message "${command}"
        check=$( eval "${command}" )
        if [ -n "${check}" ]; then
          increment_secure   "AWS AMI \"${image}\" has a valid Name tag"
        else
          increment_insecure "AWS AMI \"${image}\" does not have a valid Name tag"
        fi
      fi
    fi
  done
  # Check Instances have Name tags
  command="aws ec2 describe-instances --region \"${aws_region}\" --query \"Reservations[].Instances[].InstanceId\" --output text"
  command_message "${command}"
  instances=$( eval "${command}" )
  for instance in ${instances}; do
    for tag in Name Role Environment Owner; do
      command="aws ec2 describe-instances --region \"${aws_region}\" --instance-id \"${instance}\" --query \"Reservations[].Instances[].Tags[?Key==\\\`${tag}\\\`].Value\" --output text"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -z "${check}" ]; then
        increment_insecure "AWS Instance \"${instance}\" does not have a \"${tag}\" tag"
        verbose_message    "aws ec2 create-tags --region \"${aws_region}\" --resources \"${instance}\" --tags Key=${tag},Value=<valid_name_tag>" "fix"
      else
        if [ "${strict_valid_names}" = "y" ]; then
          command="echo \"${ansible_value}\" |grep \"^ec2-${valid_tag_string}\""
          command_message "${command}"
          check=$( eval "${command}" )
          if [ -n "${check}" ]; then
            increment_secure   "AWS Instance \"${instance}\" has a valid \"${tag}\" tag"
          else
            increment_insecure "AWS Instance \"${instance}\" does not have a valid \"${tag}\" tag"
          fi
        fi
      fi
    done
    command="aws ec2 describe-instance-attribute --region \"${aws_region}\" --instance-id \"${instance}\" --attribute disableApiTermination --query \"DisableApiTermination\" | grep -i true"
    command_message "${command}"
    term_check=$( eval "${command}" )
    command="aws autoscaling describe-auto-scaling-instances --region \"${aws_region}\" --query 'AutoScalingInstances[].InstanceId' | grep \"${instance}\""
    command_message "${command}"
    asg_check=$( eval "${command}" )
    if [ -n "${term_check}" ] && [ -z "${asg_check}" ]; then
      increment_secure   "Termination Protection is enabled for instance \"${instance}\""
    else
      increment_insecure "Termination Protection is not enabled for instance \"${instance}\""
    fi
  done
  # Check Instances are from self produced images
  command="aws ec2 describe-instances --region \"${aws_region}\" --query 'Reservations[].Instances[].ImageId' --output text"
  command_message "${command}"
  images=$( eval "${command}" )
  for image in ${images}; do
    command="aws ec2 describe-images --region \"${aws_region}\" --image-ids \"${image}\" --query 'Images[].ImageOwnerAlias' --output text"
    command_message "${command}"
    owner=$( eval "${command}" )
    if [ "${owner}" = "self" ] || [ -z "${owner}" ]; then
      increment_secure   "AWS AMI \"${image}\" is a self produced image"
    else
      
      increment_insecure "AWS AMI \"${image}\" is not have a valid Name tag"
    fi
  done
  # Check number of Elastic IPs that are being used
  command="aws ec2 describe-account-attributes --region \"${aws_region}\" --attribute-names max-elastic-ips --query \"AccountAttributes[].AttributeValues[].AttributeValue\" --output text"
  command_message "${command}"
  max_ips=$( eval "${command}" )
  command="aws ec2 describe-addresses --region \"${aws_region}\" --query 'Addresses[].PublicIp' --filters \"Name=domain,Values=standard\" --output text | wc -l | sed \"s/ //g\""
  command_message "${command}"
  no_ips=$( eval "${command}" )
  if [ "${max_ips}" -ne "${no_ips}" ]; then
    increment_secure   "Number of Elastic IPs consumed is less than limit of \"${max_ips}\""
  else
    increment_insecure "Number of Elastic IPs consumed has reached limit of \"${max_ips}\""
  fi
  # Check Instances are using EC2-VPC and not EC2-Classic
  command="aws ec2 describe-instances --region \"${aws_region}\" --query 'Reservations[*].Instances[*].InstanceId' --output text"
  command_message "${command}"
  instances=$( eval "${command}" )
  for instance in ${instances}; do
    command="aws ec2 describe-instances --region \"${aws_region}\" --instance-ids \"${instance}\" --query 'Reservations[*].Instances[*].VpcId' --output text"
    command_message "${command}"
    vpc=$( eval "${command}" )
    if [ -n "${vpc}" ]; then
      increment_secure   "Instance \"${instance}\" is an EC2-VPC platform"
    else
      increment_insecure "Instance \"${instance}\" is an EC2-Classic platform"
    fi 
  done
}

