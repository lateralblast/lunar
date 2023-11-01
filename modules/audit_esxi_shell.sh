# audit_esxi_shell
#
# Check ESXi Shell
#
# Refer to http://kb.vmware.com/kb/2004746
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-B5144CE9-F8BB-494D-8F5D-0D5621D65DAE.html
#.

audit_esxi_shell () {
  if [ "$os_name" = "VMkernel" ]; then
    service_name="ESXShell"
    verbose_message "$service_name"
    check_linux_service $service_name off
  fi
}
