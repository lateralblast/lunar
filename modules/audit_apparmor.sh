# audit_apparmor
#
# Refer to Section(s) 4.5     Page(s) 38-9  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.6.2.1 Page(s) 69-70 CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.6.3   Page(s) 73-4  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_apparmor () {
  if [ "$os_name" = "Linux" ]; then
    do_test=0
    package_name="apparmor"
    app_name="AppArmor"
    if [ "$os_vendor" = "SuSE" ]; then 
      check_list="/boot/grub/menu.lst"
      do_test=1
    fi
    if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 16 ]; then
      check_list="/boot/grub/grub.cfg /etc/default/grub"
      do_test=1
    fi
    for check_file in "$check_list"; do
      if [ "$do_test" = 1 ]; then
        verbose_message "$app_name"
        check_linux_package install $package_name
        if [ "$audit_mode" = 2 ]; then
          restore_file $check_file $restore_dir
        else
          if [ -f "$check_file" ]; then
            package_disable_test=$( grep "$package_name=0" $check_file | head -1 | wc -l )
            package_enabled_test=$( grep "$package_name=1" $check_file | head -1 | wc -l )
          else
            package_disabled_test=0
            package_enabled_test=0
          fi
          if [ "$package_disabled_test" ="1" ]; then
            increment_insecure "$app_name is disabled in $check_file"
            temp_file="$temp_dir/$package_name"
            backup_file $check_file
            if [ "$os_vendor" = "SuSE" ]; then 
              lockdown_command "cat $check_file |sed 's/$package_name=0//g' > $temp_file ; cat $temp_file > $check_file ; enforce /etc/$package_name.d/*" "Removing disabled $app_name in $check_file"
            else
              lockdown_command "cat $check_file |sed 's/$package_name=0//g' > $temp_file ; cat $temp_file > $check_file ; aa-enforce /etc/$package_name.d/*" "Removing disabled $app_name in $check_file"
            fi 
          else
            increment_secure "$app_name is not disabled in $check_file"
          fi
          if [ "$package_enabled_test" = "1" ]; then
            increment_secure "$app_name is enabled $check_file"
          else
            increment_insecure "$app_name is not enabled in $check_file"
            temp_file="$temp_dir/$package_name"
            backup_file $check_file
            if [ "$check_file" = "/etc/default/grub" ]; then
              line_check=$( grep "^GRUB_CMDLINE_LINUX" $check_file | head -1 | wc -l )
              if [ "$line_check" = "1" ]; then
                existing_value=`cat $check_file |grep "^GRUB_CMDLINE_LINUX" |cut -f2 -d= |sed "s/\"//g"`
                new_value="GRUB_CMDLINE_LINUX=\"apparmor=1 security=apparmor $existing_value\""
                lockdown_command "cat $check_file |sed 's/^GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"$new_value\"/g' > $temp_file ; cat $temp_file > $check_file" "Removing disabled $app_name"
              else
                lockdown_command "echo 'GRUB_CMDLINE_LINUX=\"apparmor=1 security=apparmor\"' >> $check_file"
              fi
            else
              if [ "$check_file" = "/boot/grub/grub.cfg" ]; then
                lockdown_command "cat $check_file |sed 's/^\s*linux.*/& apparmor=1 security=apparmor/g' > $temp_file ; cat $temp_file > $check_file ; aa-enforce /etc/$package_name.d/*" "Enabling $app_name in $check_file"
              else
                lockdown_command "cat $check_file |sed 's/^\s*kernel.*/& apparmor=1 security=apparmor/g' > $temp_file ; cat $temp_file > $check_file ; enforce /etc/$package_name.d/*" "Enabling $app_name in $check_file"
              fi
            fi
          fi
        fi
      fi
    done 
  fi
}
