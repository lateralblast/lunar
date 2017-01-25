# audit_aws_sgs
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
#.

audit_aws_sgs () {
  sgs=`aws ec2 describe-security-groups --region $aws_region --query SecurityGroups[].GroupId --output text`
  for sg in $sgs; do
    inbound=`aws ec2 describe-security-groups --region $aws_region --group-ids $sg --filters Name=group-name,Values='default' --query 'SecurityGroups[*].{IpPermissions:IpPermissions,GroupId:GroupId}' |grep "0.0.0.0/0"`
    if [ ! "$inbound" ]; then
      total=`expr $total + 1`
      secure=`expr $secure + 1`
      echo "Secure:    Security Group $sg does not have a open inbound rule [$secure Passes]"
    else
      funct_aws_open_port_check $sg 22 tcp SSH
      funct_aws_open_port_check $sg 3389 tcp RDP
    fi
    outbound=`aws ec2 describe-security-groups --region $aws_region --group-ids $sg --filters Name=group-name,Values='default' --query 'SecurityGroups[*].{IpPermissionsEgress:IpPermissionsEgress,GroupId:GroupId}' |grep "0.0.0.0/0"`
    total=`expr $total + 1`
    if [ ! "$outbound" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Security Group $sg does not have a open outbound rule [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Security Group $sg has an open outbound rule [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws ec2 revoke-security-group-egress --region $aws_region --group-name $sg --protocol tcp --cidr 0.0.0.0/0" fix
      funct_verbose_message "" fix
    fi
  done
}

