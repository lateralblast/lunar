# audit_autofs
#
# The automount daemon is normally used to automatically mount NFS file systems
# from remote file servers when needed. However, the automount daemon can also
# be configured to mount local (loopback) file systems as well, which may
# include local user home directories, depending on the system configuration.
# Sites that have local home directories configured via the automount daemon
# in this fashion will need to ensure that this daemon is running for Oracle's
# Solaris Management Console administrative interface to function properly.
# If the automount daemon is not running, the mount points created by SMC will
# not be mounted.
# Note: Since this service uses Oracle's standard RPC mechanism, it is important
# that the system's RPC portmapper (rpcbind) also be enabled when this service
# is turned on.
#
# Refer to Section(s) 2.9    Page(s) 21 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 1.1.22 Page(s) 47 CIS RHEL 7 Benchmark v1.0.0
# Refer to Section(s) 2.2.10 Page(s) 30 CIS Solaris 10 v5.1.0
# Refer to Section(s) 2.25   Page(s) 31 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.1.19 Page(s) 43 CIS Amazon Linux Benchmark v2.0.0
#.

audit_autofs () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Automount services"
      service_name="svc:/system/filesystem/autofs"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Automount services"
    service_name="autofs"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
