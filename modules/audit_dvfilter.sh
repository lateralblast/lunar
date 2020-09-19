# audit_dvfilter
#
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.ext_solutions.doc/GUID-6013E15D-92CE-4970-953C-ACCB36ADA8AD.html
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-CD0783C9-1734-4B9A-B821-ED17A77B0206.html
#.

audit_dvfilter () {
  if [ "$os_name" = "VMkernel" ]; then
    verbose_message "Dvfilter"
    backup_file="$work_dir/dvfilter"
    current_value=$( esxcli --formatter=csv --format-param=fields="Path,Int Value" system settings advanced list | grep /Net/DVFilterBindIpAddress | cut -f2 -d, )
    if [ "$audit_mode" != "2" ]; then
      if [ "$current_value" != "0" ]; then
        if [ "$audit_mode" = "0" ]; then
          echo "$current_value" > $backup_file
          verbose_message "Setting:   Dvfilter to disabled"
          esxcli system settings advanced set -o /Net/DVFilterBindIpAddress -d
        fi
        if [ "$audit_mode" = "1" ]; then
          increment_insecure "Dvfilter enabled"
          verbose_message "" fix
          verbose_message "esxcli system settings advanced set -o /Net/DVFilterBindIpAddress -d" fix
          verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          increment_secure "Dvfilter disabled"
        fi
      fi
    else
      restore_file="$restore_dir/$test"
      if [ -f "$restore_file" ]; then
        previous_value=$( cat $restore_file )
        if [ "$previous_value" != "$current_value" ]; then
          verbose_message "Restoring: Dvfilter to $previous_value"
          esxcli system settings advanced set -o /Net/DVFilterBindIpAddress -i $previous_value
        fi
      fi
    fi
  fi
}
