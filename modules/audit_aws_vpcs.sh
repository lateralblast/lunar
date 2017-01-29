# audit_aws_vpcs
#
# Refer http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/SettingLogRetention.html
# Refer to Section(s) 4.2 Page(s) 133-4  CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 4.3 Page(s) 135-7  CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 4.4 Page(s) 138-40 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 4.5 Page(s) 141-2  CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/VPC/endpoint-exposed.html
#.

audit_aws_vpcs () {
  # Check for exposed VPC endpoints
  total=`expr $total + 1`
  endpoints=`aws ec2 describe-vpc-endpoints --region $aws_region --query 'VpcEndpoints[*].VpcEndpointId' --output text`
  for enpoint in $endpoints; do
    check=`aws ec2 describe-vpc-endpoints --region $aws_region --vpc-endpoint-ids $enpoint --query 'VpcEndpoints[].PolicyDocument' |grep Principal |egrep "\*|{\"AWS\":\"\*\"}"`
    if [ "$check" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   VPC $vpc has en exposed enpoint [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    VPC $vpc does not have an exposed endpoint [$secure Passes]"
    fi
  done
  # Check for VPC peering
	peers=`aws ec2 describe-vpc-peering-connections --region $aws_region --query VpcPeeringConnections --output text`
  total=`expr $total + 1`
  if [ ! "$peers" ]; then
    secure=`expr $secure + 1`
    echo "Secure:    VPC peering is not being used [$secure Passes]"
  else
    vpcs=`aws ec2 describe-vpcs --query Vpcs[].VpcId --output text`
    for vpc in $vpcs; do
      check=`aws ec2 describe-route-tables --region $aws_region --filter "Name=vpc-id,Values=$vpc" --query "RouteTables[*].{RouteTableId:RouteTableId, VpcId:VpcId, Routes:Routes,AssociatedSubnets:Associations[*].SubnetId}" |grep GatewayID |grep pcx-`
      if [ ! "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    VPC $vpc does not have a peer as it's gateway [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   VPC peering is being used review VPC: $vpc [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws ec2 delete-route --region $aws_region --route-table-id <route_table_id> --destination-cidr-block <non_compliant_destination_CIDR>" fix
        funct_verbose_message "aws ec2 create-route --region $aws_region --route-table-id <route_table_id> --destination-cidr-block <compliant_destination_CIDR> --vpc-peering-connection-id <peering_connection_id>" fix
        funct_verbose_message "" fix
      fi
    done
  fi
  # Check for VPC flow logging
  logs=`aws ec2 describe-flow-logs --region $aws_region --query FlowLogs[].FlowLogId --output text`
  if [ "$logs" ]; then
    vpcs=`aws ec2 describe-vpcs --region $aws_region --query Vpcs[].VpcId --output text`
    for vpc in $vpcs; do
      check=`aws ec2 describe-flow-logs --region $aws_region --query FlowLogs[].ResourceId --output text`
      if [ "$check" ]; then
        active=`aws ec2 describe-flow-logs --region $aws_region --filter "Name=resource-id,Values=$vpc" |grep FlowLogStatus |grep ACTIVE`
        if [ "$active" ]; then
          secure=`expr $secure + 1`
          echo "Secure:    VPC $vpc has active flow logs [$secure Passes]"
        else
          insecure=`expr $insecure + 1`
          echo "Warning:   VPC $vpc has flow logs but they are not active [$insecure Warnings]"
        fi
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   VPC $vpc does not have flow logs [$secure Passes]"
      fi
    done
  else
    total=`expr $total + 1`
    insecure=`expr $insecure + 1`
    echo "Warning:   There are no VPC flow logs [$insecure Warnings]"
  fi
}

