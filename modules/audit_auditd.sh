# audit_auditd
#
# Check auditd is installed - Required for various other tests like docker
#
# Refer to Section(s) 4.1       Page(s) 157-8  CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 4.1.1.1-4 Page(s) 278-83 CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 4.1.4.3   Page(s) 535-6  CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 3.2       Page(s) 91     CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_auditd () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    verbose_message "Audit Daemon"
    if [ "$os_name" = "Linux" ]; then
      check_linux_package install auditd
      check_linux_package install audispd-plugins 
      check_file="/etc/default/grub"
      app_name="Audit"
      package_name="audit"
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
          lockdown_command "cat $check_file |sed 's/$package_name=0//g' > $temp_file ; cat $temp_file > $check_file ; update-grub" "Removing disabled $app_name in $check_file"
        else
          increment_secure "$app_name is not disabled in $check_file"
        fi
        if [ "$package_enabled_test" = "1" ]; then
          increment_secure "$app_name is enabled $check_file"
        else
          increment_insecure "$app_name is not enabled in $check_file"
          temp_file="$temp_dir/$package_name"
          backup_file $check_file
          line_check=$( grep "^GRUB_CMDLINE_LINUX" $check_file | head -1 | wc -l )
          if [ "$line_check" = "1" ]; then
            existing_value=`cat $check_file |grep "^GRUB_CMDLINE_LINUX" |cut -f2 -d= |sed "s/\"//g"`
            new_value="GRUB_CMDLINE_LINUX=\"audit=1 $existing_value\""
            lockdown_command "cat $check_file |sed 's/^GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"$new_value\"/g' > $temp_file ; cat $temp_file > $check_file ; update-grub" "Enabling $app_name"
          else
            lockdown_command "echo 'GRUB_CMDLINE_LINUX=\"audit=1\"' >> $check_file ; update-grub" "Enabling $app_name"
          fi
        fi
      fi
      package_name="audit_backlog_limit"
      package_value="8192"
      if [ "$audit_mode" = 2 ]; then
        restore_file $check_file $restore_dir
      else
        if [ -f "$check_file" ]; then
          package_disable_test=$( grep "$package_name=0" $check_file | head -1 | wc -l )
          package_enabled_test=$( grep "$package_name=$package_value" $check_file | head -1 | wc -l )
        else
          package_disabled_test=0
          package_enabled_test=0
        fi
        if [ "$package_disabled_test" ="1" ]; then
          increment_insecure "$app_name is disabled in $check_file"
          temp_file="$temp_dir/$package_name"
          backup_file $check_file
          lockdown_command "cat $check_file |sed 's/$package_name=0//g' > $temp_file ; cat $temp_file > $check_file ; update-grub" "Removing disabled $app_name in $check_file"
          existing_value=`cat $check_file |grep "^GRUB_CMDLINE_LINUX" |cut -f2 -d= |sed "s/\"//g"`
          new_value="GRUB_CMDLINE_LINUX=\"$package_name=$package_value $existing_value\""
          lockdown_command "cat $check_file |sed 's/^GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"$new_value\"/g' > $temp_file ; cat $temp_file > $check_file ; update-grub" "Enabling $app_name"
        else
          increment_secure "$app_name is not disabled in $check_file"
        fi
        if [ "$package_enabled_test" = "1" ]; then
          increment_secure "$app_name is enabled $check_file"
        else
          increment_insecure "$app_name is not enabled in $check_file"
          temp_file="$temp_dir/$package_name"
          backup_file $check_file
          line_check=$( grep "^GRUB_CMDLINE_LINUX" $check_file | head -1 | wc -l )
          if [ "$line_check" = "1" ]; then
            existing_value=`cat $check_file |grep "^GRUB_CMDLINE_LINUX" |cut -f2 -d= |sed "s/\"//g"`
            new_value="GRUB_CMDLINE_LINUX=\"$package_name=$package_value $existing_value\""
            lockdown_command "cat $check_file |sed 's/^GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"$new_value\"/g' > $temp_file ; cat $temp_file > $check_file ; update-grub" "Enabling $app_name"
          else
            lockdown_command "echo 'GRUB_CMDLINE_LINUX=\"$package_name=$package_value\"' >> $check_file ; update-grub" "Enabling $app_name"
          fi
        fi
      fi
    fi
    if [ "$os_name" = "Darwin" ]; then
      check_launchctl_service com.apple.auditd on
    fi
    check_file="/etc/audit/auditd.conf"
    check_file_value is $check_file log_group eq adm hash
  fi
}
