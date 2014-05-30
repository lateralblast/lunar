# audit_esxi_shell
#
# ESXi Shell is an interactive command line environment available from the
# DCUI or remotely via SSH. Access to this mode requires the root password of
# the server. The ESXi Shell can be turned on and off for individual hosts.
# Activities performed from the ESXi Shell bypass vCenter RBAC and audit
# controls. The ESXi shell should only be turned on when needed to
# troubleshoot/resolve problems that cannot be fixed through the vSphere
# client or vCLI/PowerCLI.
#
# Refer to:
#
# http://kb.vmware.com/kb/2004746
# http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-B5144CE9-F8BB-494D-8F5D-0D5621D65DAE.html
#.

audit_esxi_shell () {
  if [ "$os_name" = "VMkernel" ]; then
    funct_verbose_message "ESXi Shell"
    funct_chkconfig_service ESXShell off
  fi
}
