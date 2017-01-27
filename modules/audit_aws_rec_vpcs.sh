# audit_aws_rec_vpcs
#
# Ensure that your AWS Virtual Private Clouds (VPCs) are using appropriate
# naming conventions for tagging in order to manage them more efficiently and
# adhere to AWS resource tagging best practices. A naming convention is a
# well-defined set of rules useful for choosing the name of an AWS resource.
#
# Naming (tagging) your AWS VPCs consistently has several advantages such as
# providing additional information about the VPC location and usage, promoting
# consistency within the selected AWS region, distinguishing fast similar
# resource stacks from one another, avoiding naming collisions, improving
# clarity in cases of potential ambiguity and enhancing the aesthetic and
# professional appearance.
#
# Refer to https://www.cloudconformity.com/conformity-rules/VPC/vpc-naming-conventions.html
#
# Ensure that your AWS VPNs have both tunnels always active as a failover
# strategy in case of an outage or a planned maintenance.
#
# Using two active tunnels for your AWS VPN (IPsec) connections will ensure
# redundancy when one of the tunnels becomes unavailable. A common scenario
# where a redundant configuration is useful is when a maintenance session is
# required and you need to keep the traffic flowing between the on-premise
# network and AWS VPC without any downtime.
#
# Refer to https://www.cloudconformity.com/conformity-rules/VPC/vpn-tunnel-redundancy.html
#.

audit_aws_rec_vpcs () {
  # Check Security Groups have Name tags
  vpcs=`aws ec2 describe-vpcs --region $aws_region --query 'Vpcs[].VpcId' --output text`
  for vpc in $vpcs; do
    if [ ! "$vpc" = "default" ]; then
      total=`expr $total + 1`
      name=`aws ec2 describe-vpcs --region $aws_region --vpc-ids $vpcs --query "Vpcs[].Tags[?Key==\\\`Name\\\`].Value" 2> /dev/null --output text`
      if [ ! "$name" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   AWS VPC $vpc does not have a Name tag [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws ec2 create-tags --region $aws_region --resources $image --tags Key=Name,Value=<valid_name_tag>" fix
        funct_verbose_message "" fix
      else
        check=`echo $name |grep "^vpc-$valid_tag_string"`
        if [ "$check" ]; then
          secure=`expr $secure + 1`
          echo "Pass:      AWS VPC $vpc has a valid Name tag [$secure Passes]"
        else
          insecure=`expr $insecure + 1`
          echo "Warning:   AWS VPC $vpc does not have a valid Name tag [$insecure Warnings]"
        fi
      fi
    fi
  done
  # Check VPN tunnel redundancy 
  tunnels=`aws ec2 describe-vpn-connections --region $aws_region --query "VpnConnections[].VpnConnectionId" --output text`
  for tunnel in $tunnels; do
    check=`aws ec2 describe-vpn-connections --region $aws_region --vpc-connection-ids $tunnel --query "VpnConnections[].VgwTelemetry[].Status" |grep "DOWN"`
    if [ "$check" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   AWS VPC $vpc does not have VPN tunnel redundancy [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Pass:      AWS VPC $vpc has VPN tunnel redundancy [$secure Passes]"
    fi
  done
}

