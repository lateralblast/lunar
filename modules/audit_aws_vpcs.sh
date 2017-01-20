# audit_aws_vpcs
#
# Security groups provide stateful filtering of ingress/egress network
# traffic to AWS resources. It is recommended that no security group allows
# unrestricted ingress access to port 22.
#
# Removing unfettered connectivity to remote console services, such as SSH,
# reduces a server's exposure to risk.
#
# Security groups provide stateful filtering of ingress/egress network
# traffic to AWS resources. It is recommended that no security group
# allows unrestricted ingress access to port 3389.
# 
# Removing unfettered connectivity to remote console services, such as RDP,
# reduces a server's exposure to risk.
#
# VPC Flow Logs is a feature that enables you to capture information about
# the IP traffic going to and from network interfaces in your VPC.
# After you've created a flow log, you can view and retrieve its data in
# Amazon CloudWatch Logs. It is recommended that VPC Flow Logs be enabled
# for packet "Rejects" for VPCs.
#
# VPC Flow Logs provide visibility into network traffic that traverses the
# VPC and can be used to detect anomalous traffic or insight during security
# workflows.
#
# Note: Setting the filter to "Reject" will dramatically reduce the logging
# data accumulation for this recommendation and provide sufficient information
# for the purposes of breach detection, research and remediation. However,
# during periods of least privilege security group engineering, setting this
# the filter to "All" can be very helpful in discovering existing traffic
# flows required for proper operation of an already running environment.
#
# By default, CloudWatch Logs will store Logs indefinitely unless a specific
# retention period is defined for the log group. When choosing the number of
# days to retain, keep in mind the average days it takes an organization to
# realize they have been breached is 210 days (at the time of this writing).
# Since additional time is required to research a breach, a minimum 365 day
# retention policy allows time for detection and research. You may also wish
# to archive the logs to a cheaper storage service rather than simply deleting
# them. See the following AWS resource to manage CloudWatch Logs retention
# periods:
#
# http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/SettingLogRetention.html
#
# A VPC comes with a default security group whose initial settings deny all
# inbound traffic, allow all outbound traffic, and allow all traffic between
# instances assigned to the security group. If you don't specify a security
# group when you launch an instance, the instance is automatically assigned
# to this default security group. Security groups provide stateful filtering
# of ingress/egress network traffic to AWS resources. It is recommended that
# the default security group restrict all traffic.
#
# The default VPC in every region should have it's default security group
# updated to comply. Any newly created VPCs will automatically contain a default
# security group that will need remediation to comply with this recommendation.
#
# When implementing this recommendation, VPC flow logging is invaluable in
# determining the least privilege port access required by systems to work
# properly because it can log all packet acceptances and rejections occurring
# under the current security groups. This dramatically reduces the primary
# barrier to least privilege engineering - discovering the minimum ports
# required by systems in the environment. Even if the VPC flow logging
# recommendation in this benchmark is not adopted as a permanent security
# measure, it should be used during any period of discovery and engineering
# for least privileged security groups.
#
# Configuring all VPC default security groups to restrict all traffic will
# encourage least privilege security group development and mindful placement
# of AWS resources into security groups which will in-turn reduce the exposure
# of those resources.
#
# Once a VPC peering connection is established, routing tables must be updated
# to establish any connections between the peered VPCs. These routes can be as
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
# Refer to Section(s) 4.2 Page(s) 133-4  CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 4.3 Page(s) 135-7  CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 4.4 Page(s) 138-40 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 4.5 Page(s) 141-2  CIS AWS Foundations Benchmark v1.1.0
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
  sgs=`aws ec2 describe-security-groups --query SecurityGroups[].GroupId --output text`
  for sg in $sgs; do
    openssh=`aws ec2 describe-security-groups --group-ids $sg --filters "Name=ip-permission.to-port,Values=22" "Name=ip-permission.cidr,Values=0.0.0.0/0" --output text`
    if [ ! "$openssh" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Security Group $sg does not have SSH open to the world [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Security Group $sg has SSH open to the world [$insecure Warnings]"
    fi
    openrdp=`aws ec2 describe-security-groups --group-ids $sg --filters "Name=ip-permission.to-port,Values=3389" "Name=ip-permission.cidr,Values=0.0.0.0/0" --output text`
    if [ ! "$openrdp" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Security Group $sg does not have RDP open to the world [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Security Group $sg has RDP open to the world [$insecure Warnings]"
    fi
    inbound=`aws ec2 describe-security-groups --group-ids $sg --filters Name=group-name,Values='default' --query 'SecurityGroups[*].{IpPermissions:IpPermissions,GroupId:GroupId}' |grep "0.0.0.0/0"`
    if [ ! "$inbound" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Security Group $sg does not have a open inbound rule [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Security Group $sg has an open inbound rule [$insecure Warnings]"
    fi
    outbound=`aws ec2 describe-security-groups --group-ids $sg --filters Name=group-name,Values='default' --query 'SecurityGroups[*].{IpPermissionsEgress:IpPermissionsEgress,GroupId:GroupId}' |grep "0.0.0.0/0"`
    if [ ! "$outbound" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Security Group $sg does not have a open outbound rule [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Security Group $sg has an open outbound rule [$insecure Warnings]"
    fi
  done
  logs=`aws ec2 describe-flow-logs --query FlowLogs[].FlowLogId --output text`
  if [ "$logs" ]; then
    vpcs=`aws ec2 describe-vpcs --query Vpcs[].VpcId --output text`
    for vpc in $vpcs; do
      check=`aws ec2 describe-flow-logs --query FlowLogs[].ResourceId --output text`
      if [ "$check" ]; then
        active=`aws ec2 describe-flow-logs --filter "Name=resource-id,Values=$vpc" |grep FlowLogStatus |grep ACTIVE`
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

