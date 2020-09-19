# audit_software_update
#
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.update_manager.doc/GUID-EF6BEE4C-4583-4A8C-81B9-5B074CA2E272.html
#
# Refer to Page(s) 8 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 1.2-5 Page(s) 13-20 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_software_update() {
  if [ "$os_name" = "VMkernel" ]; then
    vmware_depot="http://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml"
    verbose_message "Software Update"
    current_update=$( esxcli software profile get 2>&1 | head -1 )
    log_file="softwareupdate.log"
    backup_file="$work_dir/$log_file"
    available_update=$( esxcli software sources profile list -d $vmware_depot | grep $os_version | head -1 | awk '{print $1}' )
    if [ "$audit_mode" != 2 ]; then
      if [ "$current_update" != "$available_update" ]; then
        if [ "$audit_mode" = 0 ]; then
          verbose_message "Notice:    Updating software"
          esxcli software profile install -d $vmware_depot -p $available_update --ok-to-remove
        fi
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Software is not up to date (Current: $current_update Available: $available_update)"
          verbose_message "" fix
          verbose_message "esxcli software profile install -d $vmware_depot -p $available_update --ok-to-remove" fix
          verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "Software is up to date"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        previous_update=$( cat $restore_file )
        if [ "$current_update" != "$previous_update" ]; then
          verbose_message "Restoring: Software to $previous_value"
          esxcli software profile install -d $vmware_depot -p $previous_update --ok-to-remove --alow-downgrades
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_release" -ge 12 ]; then
      check_osx_defaults /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled 1 int
      check_osx_defaults /Library/Preferences/com.apple.commerce AutoUpdate 1 bool
      check_osx_defaults /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall 1 bool
      check_osx_defaults /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall 1 bool
      check_osx_defaults /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired 1 bool
    else
      actual_status=$( sudo softwareupdate --schedule |awk '{print $4}' )
      verbose_message "Software Autoupdate"
      log_file="softwareupdate.log"
      correct_status="on"
      if [ "$audit_mode" != 2 ]; then
       verbose_message "If Software Update is enabled"
        if [ "$actual_status" != "$correct_status" ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Software Update is not $correct_status"
            command_line="sudo softwareupdate --schedule $correct_status"
            verbose_message "" fix
            verbose_message "$command_line" fix
            verbose_message "" fix
          else
            if [ "$audit_mode" = 0 ]; then
              log_file="$work_dir/$log_file"
              echo "$actual_status" > $log_file
              verbose_message "Setting:   Software Update schedule to $correct_status"
              sudo softwareupdate --schedule $correct_status
            fi
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "Software Update is $correct_status"
          fi
        fi
      else
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          previous_status=$( cat $restore_file )
          if [ "$previous_status" != "$actual_status" ]; then
            verbose_message "Restoring:   Software Update to $previous_status"
            sudo suftwareupdate --schedule $previous_status
          fi
        fi
      fi
    fi
  fi
}
