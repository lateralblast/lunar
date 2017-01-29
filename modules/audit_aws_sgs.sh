# audit_aws_sgs
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/security-group-ingress-any.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-ssh-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-rdp-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-cifs-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-dns-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-ftp-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-mongodb-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-netbios-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-rpc-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-icmp-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-smtp-access.html
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-telnet-access.html
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
      funct_aws_open_port_check $sg -1 icmp ICMP none none
      funct_aws_open_port_check $sg 20,21 tcp FTP none none
      funct_aws_open_port_check $sg 22 tcp SSH none none
      funct_aws_open_port_check $sg 23 tcp Telnet none none
      funct_aws_open_port_check $sg 25 tcp SMTP none none
      funct_aws_open_port_check $sg 53 tcp DNS none none
      funct_aws_open_port_check $sg 80 tcp HTTP none none
      funct_aws_open_port_check $sg 135 tcp RPC none none
      funct_aws_open_port_check $sg 137,138,139 tcp SMB none none
      funct_aws_open_port_check $sg 443 tcp HTTPS none none
      funct_aws_open_port_check $sg 445 tcp CIFS none none
      funct_aws_open_port_check $sg 1433 tcp MSSQL none none
      funct_aws_open_port_check $sg 1521 tcp Oracle none none
      funct_aws_open_port_check $sg 3306 tcp MySQL none none
      funct_aws_open_port_check $sg 3389 tcp RDP none none
      funct_aws_open_port_check $sg 5432 tcp PostgreSQL none none
      funct_aws_open_port_check $sg 27017 tcp MongoDB none none
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
