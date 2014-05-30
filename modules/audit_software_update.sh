# audit_software_update
#
# Ensure OS X is set to autoupdate
#
# Check ESXi is up to date
#
# By staying up to date on ESXi patches, vulnerabilities in the hypervisor can
# be mitigated. An educated attacker can exploit known vulnerabilities when
# attempting to attain access or elevate privileges on an ESXi host.
# Employ a process to keep ESXi hosts up to date with patches in accordance
# with industry-standards and internal guidelines. VMware also publishes
# Advisories on security patches, and offers a way to subscribe to email alerts
# for them.
#
# Refer to:
#
# http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.update_manager.doc/GUID-EF6BEE4C-4583-4A8C-81B9-5B074CA2E272.html
#
# Refer to Page(s) 8 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_software_update() {
  if [ "$os_name" = "VMkernel" ]; then
    vmware_depot="http://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml"
    funct_verbose_message "Software Update"
    current_update=`esxcli software profile get 2>&1 |head -1`
    log_file="softwareupdate.log"
    backup_file="$work_dir/$log_file"
    available_update=`esxcli software sources profile list -d $vmware_depot | grep $os_version |head -1 |awk '{print $1}'`
    if [ "$audit_mode" != 2 ]; then
      if [ "$current_update" != "$available_update" ]; then
        if [ "$audit_mode" = 0 ]; then
          esxcli software profile install -d $vmware_depot -p $available_update --ok-to-remove
        fi
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Software is not up to date (Current: $current_update Available: $available_update) [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "esxcli software profile install -d $vmware_depot -p $available_update --ok-to-remove" fix
          funct_verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Software is up to date [$secure Passes]"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        previous_update=`cat $restore_file`
        if [ "$current_update" != "$previous_update" ]; then
          esxcli software profile install -d $vmware_depot -p $previous_update --ok-to-remove --alow-downgrades
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Darwin" ]; then
    actual_status=`sudo softwareupdate --schedule |awk '{print $4}'`
    funct_verbose_message "Software Autoupdate"
    log_file="softwareupdate.log"
    correct_status="on"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  If Software Update is enabled"
      total=`expr $total + 1`
      if [ "$actual_status" != "$correct_status" ]; then
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Software Update is not $correct_status [$insecure Warnings]"
          command_line="sudo softwareupdate --schedule $correct_status"
          funct_verbose_message "" fix
          funct_verbose_message "$command_line" fix
          funct_verbose_message "" fix
        else
          if [ "$audit_mode" = 0 ]; then
            log_file="$work_dir/$log_file"
            echo "$actual_status" > $log_file
            echo "Setting:   Software Update schedule to $correct_status"
            sudo softwareupdate --schedule $correct_status
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Software Update is $correct_status [$secure Passes]"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        previous_status=`cat $restore_file`
        if [ "$previous_status" != "$actual_status" ]; then
          funct_verbose_message ""
          funct_verbose_message "Restoring:   Software Update to $previous_status"
          funct_verbose_message ""
          sudo suftwareupdate --schedule $previous_status
        fi
      fi
    fi
  fi
}
