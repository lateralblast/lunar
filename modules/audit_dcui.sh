# audit_dcui
#
# The DCUI allows for low-level host configuration such as configuring IP
# address, hostname and root password as well as diagnostic capabilities
# such as enabling the ESXi shell, viewing log files, restarting agents, and
# resetting configurations. Actions performed from the DCUI are not tracked
# by vCenter Server. Even if Lockdown Mode is enabled, users who are members
# of the DCUI.
# Access list can perform administrative tasks in the DCUI bypassing RBAC and
# auditing controls provided through vCenter.  DCUI access can be disabled.
# Disabling it prevents all local activity and thus forces actions to be
# performed in vCenter Server where they can be centrally audited and monitored.
#
# Refer to:
#
# http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-6779F098-48FE-4E22-B116-A8353D19FF56.html
#.

audit_dcui () {
  if [ "$os_name" = "VMkernel" ]; then
    funct_verbose_message "DCUI"
    funct_chkconfig_service DCUI off
  fi
}
