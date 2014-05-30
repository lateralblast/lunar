# audit_dvfilter
#
# f you are not using products that make use of the dvfilter network API
# (e.g. VMSafe), the host should not be configured to send network information
# to a VM. If the API is enabled, an attacker might attempt to connect a VM to
# it, thereby potentially providing access to the network of other VMs on the
# host. If you are using a product that makes use of this API then verify that
# the host has been configured correctly.
#
# Refer to:
#
# http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.ext_solutions.doc/GUID-6013E15D-92CE-4970-953C-ACCB36ADA8AD.html
# http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-CD0783C9-1734-4B9A-B821-ED17A77B0206.html
#.

audit_dvfilter () {
  if [ "$os_name" = "VMkernel" ]; then
    funct_verbose_message "Dvfilter"
    total=`expr $total + 1`
    backup_file="$work_dir/dvfilter"
    current_value=`esxcli --formatter=csv --format-param=fields="Path,Int Value" system settings advanced list | grep /Net/DVFilterBindIpAddress |cut -f2 -d,`
    if [ "$audit_mode" != "2" ]; then
      if [ "$current_value" != "0" ]; then
        if [ "$audit_more" = "0" ]; then
          echo "$current_value" > $backup_file
          echo "Setting:   Dvfilter to disabled"
          esxcli system settings advanced set -o /Net/DVFilterBindIpAddress -d
        fi
        if [ "$audit_mode" = "1" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Dvfilter enabled [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "esxcli system settings advanced set -o /Net/DVFilterBindIpAddress -d" fix
          funct_verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Dvfilter disabled [$secure Passes]"
          echo ""
        fi
      fi
    else
      restore_file="$restore_dir/$test"
      if [ -f "$restore_file" ]; then
        previous_value=`cat $restore_file`
        if [ "$previous_value" != "$current_value" ]; then
          echo "Restoring: Dvfilter to $previous_value"
          esxcli system settings advanced set -o /Net/DVFilterBindIpAddress -i $previous_value
        fi
      fi
    fi
  fi
}
