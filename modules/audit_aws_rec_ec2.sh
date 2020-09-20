# audit_aws_rec_ec2
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
  verbose_message "EC2 Recommendations"
  volumes=$( aws ec2 describe-volumes --region $aws_region --query 'Volumes[].VolumeId' --output text )
  for volume in $volumes; do
    if [ "${check_volattach}" = "y" ]; then
      # Check for EC2 volumes that are unattached
      check=$( aws ec2 describe-volumes --region $aws_region --volume-id $volume --query 'Volumes[].State' --output text )
      if [ ! "$check" = "available" ]; then
        increment_secure "EC2 volume $volume is attached to an instance"
      else
        increment_insecure "EC2 volume $volume is not attached to an instance"
      fi
    fi
    if [ "${check_volattach}" = "y" ]; then
      # Check that EC2 volumes are using cost effective storage
      check=$( aws ec2 describe-volumes --region $aws_region --volume-id $volume --query 'Volumes[].VolumeType' | grep "gp2" )
      if [ "$check" ]; then
        increment_secure "EC2 volume $volume is using General Purpose SSD"
      else
        increment_insecure "EC2 volume $volume is not using General Purpose SSD"
      fi
    fi
  done
  # Check date of snapshots
  if [ "${check_snapage}" = "y" ]; then
    arn=$( aws iam get-user --query "User.Arn" --output text | cut -f5 -d: )
    snapshots=$( aws ec2 describe-snapshots --region $aws_region --owner-ids $arn --filters Name=status,Values=completed --query "Snapshots[].SnapshotId" --output text )
    counter=0
    for snapshot in $snapshots; do
      snap_date=$( aws ec2 describe-snapshots --region $aws_region --snapshot-id $snapshot --query "Snapshots[].StartTime" --output text --output text | cut -f1 -d. )
      if [ "$os_name" = "Linux" ]; then
        snap_secs=$( date -d "$snap_date" "+%s" )
      else
        snap_secs=$( date -j -f "%Y-%m-%dT%H:%M:%S" "$snap_date" "+%s" )
      fi
      curr_secs=$( date "+%s" )
      diff_days=$( echo "($curr_secs - $snap_secs)/84600" | bc )
      if [ "$diff_days" -gt "$aws_ec2_max_retention" ]; then
        increment_insecure "EC2 snapshot $snapshot is more than $aws_ec2_max_retention days old"
      else
        increment_secure "EC2 snapshot $snapshot is less than $aws_ec2_max_retention days old"
      fi
      if [ "$diff_days" -gt "$aws_ec2_min_retention" ]; then
        counter=$( expr $counter + 1 )
      fi
    done
    if [ "$counter" -gt 0 ]; then
      increment_secure "There are EC2 snapshots more than $aws_ec2_min_retention days old"
    else
      increment_insecure "There are no EC2 snapshots more than $aws_ec2_min_retention days old"
    fi
  fi
  # Check Security Groups have Name tags
  sgs=$( aws ec2 describe-security-groups --region $aws_region --query 'SecurityGroups[].GroupId' --output text )
  for sg in $sgs; do
    if [ ! "$sg" = "default" ]; then
      name=$( aws ec2 describe-security-groups --region $aws_region --group-id $sg --query "SecurityGroups[].Tags[?Key==\\\`Name\\\`].Value" 2> /dev/null --output text )
      if [ ! "$name" ]; then
        increment_insecure "AWS Security Group $sg does not have a Name tag"
        verbose_message "" fix
        verbose_message "aws ec2 create-tags --region $aws_region --resources $image --tags Key=Name,Value=<valid_name_tag>" fix
        verbose_message "" fix
      else
        if [ "${strict_valid_names}" = "y" ]; then
          check=$( echo ${name} |grep "^sg-$valid_tag_string" )
          if [ "$check" ]; then
            increment_secure "AWS Security Group $sg has a valid Name tag"
          else
            increment_insecure "AWS Security Group $sg does not have a valid Name tag"
          fi
        fi
      fi
    fi
  done
  # Check Volumes have Name tags
  volumes=$( aws ec2 describe-volumes --region $aws_region --query "Volumes[].VolumeId" --output text )
  for volume in $volumes; do
    name=$( aws ec2 describe-volumes --region $aws_region --volume-id $volume --query "Volumes[].Tags[?Key==\\\`Name\\\`].Value" --output text )
    if [ ! "$name" ]; then
      increment_insecure "AWS EC2 volume $volume does not have a Name tag"
      verbose_message "" fix
      verbose_message "aws ec2 create-tags --region $aws_region --resources $volume --tags Key=Name,Value=<valid_name_tag>" fix
      verbose_message "" fix
    else
      if [ "${strict_valid_names}" = "y" ]; then
        check=$( echo $name |grep "^ami-$valid_tag_string" )
        if [ "$check" ]; then
          increment_secure "AWS EC2 volume $volume has a valid Name tag"
        else
          increment_insecure "AWS EC2 volume $volume does not have a valid Name tag"
        fi
      fi
    fi
  done
  # Check AMIs have Name tags
  images=$( aws ec2 describe-images --region $aws_region --owners self --query "Images[].ImageId" --output text )
  for image in $images; do
	  name=$( aws ec2 describe-images --region $aws_region --owners self --image-id $image --query "Images[].Tags[?Key==\\\`Name\\\`].Value" --output text )
    if [ ! "$name" ]; then
      increment_insecure "AWS AMI $image does not have a Name tag"
      verbose_message "" fix
      verbose_message "aws ec2 create-tags --region $aws_region --resources $image --tags Key=Name,Value=<valid_name_tag>" fix
      verbose_message "" fix
    else
      if [ "${strict_valid_names}" = "y" ]; then
        check=$( echo $name |grep "^ami-$valid_tag_string" )
        if [ "$check" ]; then
          increment_secure "AWS AMI $image has a valid Name tag"
        else
          increment_insecure "AWS AMI $image does not have a valid Name tag"
        fi
      fi
    fi
  done
  # Check Instances have Name tags
  instances=$( aws ec2 describe-instances --region $aws_region --query "Reservations[].Instances[].InstanceId" --output text )
  for instance in $instances; do
    for tag in Name Role Environment Owner; do
      check=$( aws ec2 describe-instances --region $aws_region --instance-id $instance --query "Reservations[].Instances[].Tags[?Key==\\\`$tag\\\`].Value" --output text )
      if [ ! "$check" ]; then
        increment_insecure "AWS Instance $instance does not have a $tag tag"
        verbose_message "" fix
        verbose_message "aws ec2 create-tags --region $aws_region --resources $instance --tags Key=$tag,Value=<valid_name_tag>" fix
        verbose_message "" fix
      else
        if [ "${strict_valid_names}" = "y" ]; then
          check=$( echo $name |grep "^ec2-$valid_tag_string" )
          if [ "$check" ]; then
            increment_secure "AWS Instance $instance has a valid $tag tag"
          else
            increment_insecure "AWS Instance $instance does not have a valid $tag tag"
          fi
        fi
      fi
    done
    term_check=$( aws ec2 describe-instance-attribute --region $aws_region --instance-id $instance --attribute disableApiTermination --query "DisableApiTermination" | grep -i true )
    asg_check=$( aws autoscaling describe-auto-scaling-instances --region $aws_region --query 'AutoScalingInstances[].InstanceId' | grep $instance )
    if [ "$term_check" ] && [ ! "$asg_check" ]; then
      increment_secure "Termination Protection is enabled for instance $instance"
    else
      increment_insecure "Termination Protection is not enabled for instance $instance"
    fi
  done
  # Check Instances are from self produced images
  images=$( aws ec2 describe-instances --region $aws_region --query 'Reservations[].Instances[].ImageId' --output text )
  for image in $images; do
    owner=$( aws ec2 describe-images --region $aws_region --image-ids $image --query 'Images[].ImageOwnerAlias' --output text )
    if [ "$owner" = "self" ] || [ ! "$owner" ]; then
      increment_secure "AWS AMI $image is a self produced image"
    else
      
      increment_insecure "AWS AMI $image is not have a valid Name tag"
    fi
  done
  # Check number of Elastic IPs that are being used
  max_ips=$( aws ec2 describe-account-attributes --region $aws_region --attribute-names max-elastic-ips --query "AccountAttributes[].AttributeValues[].AttributeValue" --output text )
  no_ips=$( aws ec2 describe-addresses --region $aws_region --query 'Addresses[].PublicIp' --filters "Name=domain,Values=standard" --output text | wc -l )
  if [ "$max_ips" -ne  "$no_ips" ]; then
    increment_secure "Number of Elastic IPs consumed is less than limit of $max_ips"
  else
    increment_insecure "Number of Elastic IPs consumed has reached limit of $max_ips"
  fi
  # Check Instances are using EC2-VPC and not EC2-Classic
  instances=$( aws ec2 describe-instances --region $aws_region --query 'Reservations[*].Instances[*].InstanceId' --output text )
  for instance in $instances; do
    vpc_id=$( aws ec2 describe-instances --region $aws_region --instance-ids $instance --query 'Reservations[*].Instances[*].VpcId' --output text )
    if [ "$vpc_id" ]; then
      increment_secure "Instance $instance is an EC2-VPC platform"
    else
      increment_insecure "Instance $instance is an EC2-Classic platform"
    fi 
  done
}

