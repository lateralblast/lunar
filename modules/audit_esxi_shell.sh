# audit_esxi_shell
#
# Refer to http://kb.vmware.com/kb/2004746
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-B5144CE9-F8BB-494D-8F5D-0D5621D65DAE.html
#.

audit_esxi_shell () {
  if [ "$os_name" = "VMkernel" ]; then
    verbose_message "ESXi Shell"
    check_chkconfig_service ESXShell off
  fi
}
