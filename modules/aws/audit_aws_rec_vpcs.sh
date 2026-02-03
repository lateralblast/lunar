#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_rec_vpcs
#
# Check AWS VPC recommendations
#
# Refer to https://www.cloudconformity.com/conformity-rules/VPC/vpc-naming-conventions.html
# Refer to https://www.cloudconformity.com/conformity-rules/VPC/vpn-tunnel-redundancy.html
#.

audit_aws_rec_vpcs () {
  print_function  "audit_aws_rec_vpcs"
  verbose_message "VPC Recommendations" "check"
  # Check Security Groups have Name tags
  command="aws ec2 describe-vpcs --region \"${aws_region}\" --query 'Vpcs[].VpcId' --output text"
  command_message "${command}"
  vpcs=$( eval "${command}" )
  for vpc in ${vpcs}; do
    if [ ! "${vpc}" = "default" ]; then
      command="aws ec2 describe-vpcs --region \"${aws_region}\" --vpc-ids \"${vpcs}\" --query \"Vpcs[].Tags[?Key==\\\`Name\\\`].Value\" 2> /dev/null --output text"
      command_message "${command}"
      ansible_value=$( eval "${command}" )
      if [ -z "${ansible_value}" ]; then
        increment_insecure "AWS VPC ${vpc} does not have a Name tag"
        verbose_message    "aws ec2 create-tags --region ${aws_region} --resources ${image} --tags Key=Name,Value=<valid_name_tag>" "fix"
      else
        if [ "${strict_valid_names}" = "y" ]; then
          command="echo \"${ansible_value}\" |grep \"^vpc-$valid_tag_string\""
          command_message "${command}"
          check=$( eval "${command}" )
          if [ "${check}" ]; then
            increment_secure   "AWS VPC \"${vpc}\" has a valid Name tag"
          else
            increment_insecure "AWS VPC \"${vpc}\" does not have a valid Name tag"
          fi
        fi
      fi
    fi
  done
  # Check VPN tunnel redundancy 
  command="aws ec2 describe-vpn-connections --region \"${aws_region}\" --query \"VpnConnections[].VpnConnectionId\" --output text"
  command_message "${command}"
  tunnels=$( eval "${command}" )
  for tunnel in ${tunnels}; do
    command="aws ec2 describe-vpn-connections --region \"${aws_region}\" --vpc-connection-ids \"${tunnel}\" --query \"VpnConnections[].VgwTelemetry[].Status\" |grep \"DOWN\""
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_insecure   "AWS VPC \"${vpc}\" does not have VPN tunnel redundancy"
    else
      increment_secure     "AWS VPC \"${vpc}\" has VPN tunnel redundancy"
    fi
  done
}

