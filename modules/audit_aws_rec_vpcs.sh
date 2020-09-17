# audit_aws_rec_vpcs
#
# Refer to https://www.cloudconformity.com/conformity-rules/VPC/vpc-naming-conventions.html
# Refer to https://www.cloudconformity.com/conformity-rules/VPC/vpn-tunnel-redundancy.html
#.

audit_aws_rec_vpcs () {
  verbose_message "VPC Recommendations"
  # Check Security Groups have Name tags
  vpcs=$( aws ec2 describe-vpcs --region $aws_region --query 'Vpcs[].VpcId' --output text )
  for vpc in $vpcs; do
    if [ ! "$vpc" = "default" ]; then
      name=$( aws ec2 describe-vpcs --region $aws_region --vpc-ids $vpcs --query "Vpcs[].Tags[?Key==\\\`Name\\\`].Value" 2> /dev/null --output text )
      if [ ! "$name" ]; then
        increment_insecure "AWS VPC $vpc does not have a Name tag"
        verbose_message "" fix
        verbose_message "aws ec2 create-tags --region $aws_region --resources $image --tags Key=Name,Value=<valid_name_tag>" fix
        verbose_message "" fix
      else
        if [ "${strict_valid_names}" = "y" ]; then
          check=$( echo $name |grep "^vpc-$valid_tag_string" )
          if [ "$check" ]; then
            increment_secure "AWS VPC $vpc has a valid Name tag"
          else
            increment_insecure "AWS VPC $vpc does not have a valid Name tag"
          fi
        fi
      fi
    fi
  done
  # Check VPN tunnel redundancy 
  tunnels=$( aws ec2 describe-vpn-connections --region $aws_region --query "VpnConnections[].VpnConnectionId" --output text )
  for tunnel in $tunnels; do
    check=$( aws ec2 describe-vpn-connections --region $aws_region --vpc-connection-ids $tunnel --query "VpnConnections[].VgwTelemetry[].Status" |grep "DOWN" )
    if [ "$check" ]; then
      increment_insecure "AWS VPC $vpc does not have VPN tunnel redundancy"
    else
      increment_secure "AWS VPC $vpc has VPN tunnel redundancy"
    fi
  done
}

