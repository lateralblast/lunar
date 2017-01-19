# audit_aws_vpcs
#
# Once a VPC peering connection is estalished, routing tables must be updated to
# establish any connections between the peered VPCs. These routes can be as
# specific as desired - even peering a VPC to only a single host on the other
# side of the connection.
#
# Being highly selective in peering routing tables is a very effective way of
# minimizing the impact of breach as resources outside of these routes are
# inaccessible to the peered VPC.
#
# Review routing tables of peered VPCs for whether they route all subnets of
# each VPC and whether that is necessary to accomplish the intended purposes
# for peering the VPCs.
#
# Refer to Section(s) 4.5 Page(s) 141-2 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_vpcs () {
	peers=`aws ec2 describe-vpc-peering-connections --query VpcPeeringConnections --output text`
  total=`expr $total + 1`
  if [ ! "$peers" ]; then
    secure=`expr $secure + 1`
    echo "Secure:    VPC peering is not being used [$secure Passes]"
  else
    vpcs=`aws ec2 describe-vpcs --query Vpcs[].VpcId --output text`
    for vpc in $vpcs; do
      check=`aws ec2 describe-route-tables --filter "Name=vpc-id,Values=$vpc" --query "RouteTables[*].{RouteTableId:RouteTableId, VpcId:VpcId, Routes:Routes,AssociatedSubnets:Associations[*].SubnetId}" |grep GatewayID |grep pcx-`
      if [ ! "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    VPC $vpc does not have a peer as it's gateway [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   VPC peering is being used review VPC: $vpc [$insecure Warnings]"
      fi
    done
  fi
}

