#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_esxi_shell
#
# Check ESXi Shell
#
# Refer to http://kb.vmware.com/kb/2004746
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-B5144CE9-F8BB-494D-8F5D-0D5621D65DAE.html
#.

audit_esxi_shell () {
  print_module "audit_esxi_shell"
  if [ "${os_name}" = "VMkernel" ]; then
    verbose_message     "ESXShell" "check"
    check_linux_service "ESXShell" "off"
  fi
}
