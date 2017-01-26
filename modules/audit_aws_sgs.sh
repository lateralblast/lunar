# audit_aws_sgs
#
# Check your EC2 security groups for inbound rules that allow unrestricted
# access (i.e. 0.0.0.0/0) to any uncommon TCP and UDP ports and restrict access
# to only those IP addresses that require it in order to implement the principle
# of least privilege and reduce the possibility of a breach. A uncommon port
# can be any TCP/UDP port that is not included in the common services ports
# category, i.e. other than the commonly used ports such as 80 (HTTP),
# 443 (HTTPS), 20/21 (FTP), 22 (SSH), 23 (Telnet), 3389 (RDP), 1521 (Oracle),
# 3306 (MySQL), 5432 (PostgreSQL), 53 (DNS), 1433 (MSSQL) and
# 137/138/139/445 (SMB/CIFS).
#
# Allowing unrestricted (0.0.0.0/0) inbound/ingress access to uncommon ports can
# increase opportunities for malicious activity such as hacking, data loss and
# all multiple types of attacks (brute-force attacks, Denial of Service (DoS)
# attacks, etc).
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/security-group-ingress-any.html
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
# Check your EC2 security groups for inbound rules that allow unrestricted
# access (i.e. 0.0.0.0/0) to TCP port 22. Restrict access to only those IP
# addresses that require it, in order to implement the principle of least
# privilege and reduce the possibility of a breach. TCP port 22 is used for
# secure remote login by connecting an SSH client application with an SSH
# server.
#
# Allowing unrestricted SSH access can increase opportunities for malicious
# activity such as hacking, man-in-the-middle attacks (MITM) and brute-force
# attacks.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-ssh-access.html
#
# Check your EC2 security groups for inbound rules that allow unrestricted
# access (i.e. 0.0.0.0/0) to TCP port 3389 and restrict access to only those IP
# addresses that require it in order to implement the principle of least
# privilege and reduce the possibility of a breach. TCP port 3389 is used for
# secure remote GUI login to Microsoft servers by connecting an RDP (Remote
# Desktop Protocol) client application with an RDP server.
#
# Allowing unrestricted RDP access can increase opportunities for malicious
# activity such as hacking, man-in-the-middle attacks (MITM) and Pass-the-Hash
# (PtH) attacks.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-rdp-access.html
#
# Check your EC2 security groups for inbound rules that allow unrestricted
# access (i.e. 0.0.0.0/0) to TCP port 445 and restrict access to only those
# IP addresses that require it in order to implement the principle of least
# privilege and reduce the possibility of a breach. Common Internet File
# System (CIFS) port 445 is used by client/server applications to provide
# shared access to files, printers and communications between network nodes
# directly over TCP (without NetBIOS) in Microsoft Windows Server 2003 and
# later. CIFS is based on the enhanced version of Server Message Block (SMB)
# protocol for internet/intranet file sharing, developed by Microsoft.
#
# Allowing unrestricted CIFS access can increase opportunities for malicious
# activity such as man-in-the-middle attacks (MITM), Denial of Service (DoS)
# attacks or the Windows Null Session Exploit.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-cifs-access.html
#
# Check your EC2 security groups for inbound rules that allow unrestricted
# access (i.e. 0.0.0.0/0) to TCP and UDP port 53 and restrict access to only
# those IP addresses that require it in order to implement the principle of
# least privilege and reduce the possibility of a breach. TCP/UDP port 53 is
# used by the Domain Name Service during DNS resolution (DNS lookup), when the
# requests are sent from DNS clients to DNS servers or between DNS servers
#
# Allowing unrestricted DNS access can increase opportunities for malicious
# activity such as such as Denial of Service (DoS) attacks or Distributed Denial
# of Service (DDoS) attacks.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-dns-access.html
#
# Check your EC2 security groups for inbound rules that allow unrestricted access
# (i.e. 0.0.0.0/0) to TCP ports 20 and 21 and restrict access to only those IP
# addresses that require it in order to implement the principle of least
# privilege and reduce the possibility of a breach. TCP ports 20 and 21 are used
# for data transfer and communication by the File Transfer Protocol (FTP)
# client-server applications
#
# Allowing unrestricted FTP access can increase opportunities for malicious
# activity such as brute-force attacks, FTP bounce attacks, spoofing attacks
# and packet capture.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-ftp-access.html
#
# Check your EC2 security groups for inbound rules that allow unrestricted access
# (i.e. 0.0.0.0/0) to TCP port 27017 and restrict access to only those IP
# addresses that require it in order to implement the principle of least
# privilege and reduce the possibility of a breach. TCP port 27017 is used by
# the MongoDB Database which is free and open-source cross-platform document-
# oriented NoSQL database
#
# Allowing unrestricted MongoDB Database access can increase opportunities for
# malicious activity such as hacking, denial-of-service (DoS) attacks and loss
# of data.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-mongodb-access.html
#
# Check your EC2 security groups for inbound rules that allow unrestricted access
# (0.0.0.0/0) to TCP port 139 and UDP ports 137 and 138 and restrict access to
# only those IP addresses that require it in order to implement the principle of
# least privilege and reduce the possibility of a breach. These ports are used
# for NetBIOS name resolution (i.e. mapping a NetBIOS name to an IP address) by
# services such as File and Printer Sharing service running on Microsoft Windows
# Server OS.
#
# Allowing unrestricted NetBIOS access can increase opportunities for malicious
# activity such as man-in-the-middle attacks (MITM), Denial of Service (DoS)
# attacks or BadTunnel exploits.
#
# Refer to https://www.cloudconformity.com/conformity-rules/EC2/unrestricted-netbios-access.html
#
# Check your EC2 security groups for inbound rules that allow unrestricted access
# (i.e. 0.0.0.0/0) to TCP port 135 and restrict access to only those IP addresses
# that require it in order to implement the principle of least privilege and
# reduce the possibility of a breach. Remote Procedure Call (RPC) port 135 is
# used for client/server communication by Microsoft Message Queuing (MSMQ) as
# well as other Microsoft Windows/Windows Server software.
#
# Allowing unrestricted RPC access can increase opportunities for malicious
# activity such as hacking (backdoor command shell), denial-of-service (DoS)
# attacks and loss of data.
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
      funct_aws_open_port_check $sg 20,21 tcp FTP 
      funct_aws_open_port_check $sg 53 tcp DNS
      funct_aws_open_port_check $sg 80 tcp HTTP 
      funct_aws_open_port_check $sg 135 tcp RPC 
      funct_aws_open_port_check $sg 137,138,139 tcp SMB
      funct_aws_open_port_check $sg 443 tcp HTTPS 
      funct_aws_open_port_check $sg 445 tcp CIFS
      funct_aws_open_port_check $sg 1433 tcp MSSQL
      funct_aws_open_port_check $sg 1521 tcp Oracle
      funct_aws_open_port_check $sg 3306 tcp MySQL
      funct_aws_open_port_check $sg 3389 tcp RDP
      funct_aws_open_port_check $sg 5432 tcp PostgreSQL 
      funct_aws_open_port_check $sg 27017 tcp MongoDB
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

