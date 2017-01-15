# audit_ssh_config
#
# Configure SSH
# SSH Protocol to 2
# SSH X11Forwarding
# SSH MaxAuthTries to 3
# SSH MaxAuthTriesLog to 0
# SSH IgnoreRhosts to yes
# SSH RhostsAuthentication to no
# SSH RhostsRSAAuthentication to no
# SSH root login
# SSH PermitEmptyPasswords to no
# SSH Banner
# Warning Banner for the SSH Service
#
# SSH is a secure, encrypted replacement for common login services such as
# telnet, ftp, rlogin, rsh, and rcp.
# It is strongly recommended that sites abandon older clear-text login
# protocols and use SSH to prevent session hijacking and sniffing of
# sensitive data off the network. Most of these settings are the default
# in Solaris 10 with the following exceptions:
# MaxAuthTries (default is 6)
# MaxAuthTriesLog (default is 3)
# Banner (commented out)
# X11Forwarding (default is "yes")
#
# SSH supports two different and incompatible protocols: SSH1 and SSH2.
# SSH1 was the original protocol and was subject to security issues.
# SSH2 is more advanced and secure.
# Secure Shell version 2 (SSH2) is more secure than the legacy SSH1 version,
# which is being deprecated.
#
# The X11Forwarding parameter provides the ability to tunnel X11 traffic
# through the connection to enable remote graphic connections.
# Disable X11 forwarding unless there is an operational requirement to use
# X11 applications directly. There is a small risk that the remote X11 servers
# of users who are logged in via SSH with X11 forwarding could be compromised
# by other users on the X11 server. Note that even if X11 forwarding is disabled
# that users can may be able to install their own forwarders.
#
# The MaxAuthTries paramener specifies the maximum number of authentication
# attempts permitted per connection. The default value is 6.
# Setting the MaxAuthTries parameter to a low number will minimize the risk of
# successful brute force attacks to the SSH server.
#
# The MaxAuthTriesLog parameter specifies the maximum number of failed
# authorization attempts before a syslog error message is generated.
# The default value is 3.
# Setting this parameter to 0 ensures that every failed authorization is logged.
#
# The IgnoreRhosts parameter specifies that .rhosts and .shosts files will not
# be used in RhostsRSAAuthentication or HostbasedAuthentication.
# Setting this parameter forces users to enter a password when authenticating
# with SSH.
#
# The RhostsAuthentication parameter specifies if authentication using rhosts
# or /etc/hosts.equiv is permitted. The default is no.
# Rhosts authentication is insecure and should not be permitted.
# Note that this parameter only applies to SSH protocol version 1.
#
# The RhostsRSAAuthentication parameter specifies if rhosts or /etc/hosts.equiv
# authentication together with successful RSA host authentication is permitted.
# The default is no.
# Rhosts authentication is insecure and should not be permitted, even with RSA
# host authentication.
#
# The PermitRootLogin parameter specifies if the root user can log in using
# ssh(1). The default is no.
# The root user must be restricted from directly logging in from any location
# other than the console.
#
# The PermitEmptyPasswords parameter specifies if the server allows login to
# accounts with empty password strings.
# All users must be required to have a password.
#
# The Banner parameter specifies a file whose contents must sent to the remote
# user before authentication is permitted. By default, no banner is displayed.
# Banners are used to warn connecting users of the particular site's policy
# regarding connection. Consult with your legal department for the appropriate
# warning banner for your site.
#
# Refer to Section(s) 6.2.1-15 Page(s) 127-137 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.2.1-15 Page(s) 147-159 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.2.1-15 Page(s) 130-141 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.2.1-16 Page(s) 218-37  CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 9.2.1-15 Page(s) 121-131 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.9 Page(s) 57-60   CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 1.2      Page(s) 2-3     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 6.3-7    Page(s) 47-51   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.1.1-11 Page(s) 78-87   CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.2.1-16 Page(s) 201-18  CIS Amazon Linux Benchmark v2.0.0
#
# The ESXi shell, when enabled, can be accessed directly from the host console
# through the DCUI or remotely using SSH. Remote access to the host should be
# limited to the vSphere Client, remote command-line tools (vCLI/PowerCLI), and
# through the published APIs. Under normal circumstances remote access to the
# host using SSH should be disabled.
#
# Refer to:
#
# http://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.vsphere.security.doc%2FGUID-12E27BF3-3769-4665-8769-DA76C2BC9FFE.html
#.

audit_ssh_config () {
  if [ "$os_name" = "VMkernel" ]; then
    funct_verbose_message "SSH"
    funct_chkconfig_service SSH off
  fi
  if [ "$os-name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "SSH Configuration"
    if [ "$os_name" = "Darwin" ]; then
      check_file="/etc/sshd_config"
      funct_file_value $check_file GSSAPIAuthentication space yes hash
      funct_file_value $check_file GSSAPICleanupCredentials space yes hash
    else
      check_file="/etc/ssh/sshd_config"
    fi
    funct_check_perms $check_file 0600 root root
    #funct_file_value $check_file Host space "*" hash
    funct_file_value $check_file Protocol space 2 hash
    funct_file_value $check_file X11Forwarding space no hash
    funct_file_value $check_file MaxAuthTries space 3 hash
    funct_file_value $check_file MaxAuthTriesLog space 0 hash
    funct_file_value $check_file RhostsAuthentication space no hash
    funct_file_value $check_file IgnoreRhosts space yes hash
    funct_file_value $check_file StrictModes space yes hash
    funct_file_value $check_file AllowTcpForwarding space no hash
    funct_file_value $check_file ServerKeyBits space 1024 hash
    funct_file_value $check_file GatewayPorts space no hash
    funct_file_value $check_file RhostsRSAAuthentication space no hash
    funct_file_value $check_file PermitRootLogin space no hash
    funct_file_value $check_file PermitEmptyPasswords space no hash
    funct_file_value $check_file PermitUserEnvironment space no hash
    funct_file_value $check_file HostbasedAuthentication space no hash
    funct_file_value $check_file Banner space /etc/issue hash
    funct_file_value $check_file PrintMotd space no hash
    funct_file_value $check_file ClientAliveInterval space 300 hash
    funct_file_value $check_file ClientAliveCountMax space 0 hash
    funct_file_value $check_file LogLevel space VERBOSE hash
    funct_file_value $check_file RSAAuthentication space no hash
    funct_file_value $check_file UsePrivilegeSeparation space yes hash
    funct_file_value $check_file LoginGraceTime space 120 hash
    # Check for kerberos
    check_file="/etc/krb5/krb5.conf"
    if [ -f "$check_file" ]; then
      admin_check=`cat $check_file |grep -v '^#' |grep "admin_server" |cut -f2 -d= |sed 's/ //g' |wc -l |sed 's/ //g'`
      if [ "$admin_server" != "0" ]; then
        check_file="/etc/ssh/sshd_config"
        funct_file_value $check_file GSSAPIAuthentication space yes hash
        funct_file_value $check_file GSSAPIKeyExchange space yes hash
        funct_file_value $check_file GSSAPIStoreDelegatedCredentials space yes hash
        funct_file_value $check_file UsePAM space yes hash
        #funct_file_value $check_file Host space "*" hash
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      funct_file_value $check_file sshd_enable eq YES hash
    fi
    #
    # Additional options:
    # Review these options if required, eg using PAM or Kerberos/AD
    #
    #
    #
    # Enable on new machines
    # funct_file_value $check_file Cipher space "aes128-ctr,aes192-ctr,aes256-ctr" hash
  fi
}
