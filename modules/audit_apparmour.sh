# audit_apparmour
#
# Refer to Section(s) 4.5     Page(s) 38-9  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.6.2.1 Page(s) 69-70 CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.6.3   Page(s) 73-4  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_apparmour () {
  if [ "$os_name" = "Linux" ]; then
    do_test=0
    package_name="apparmor"
    app_name="AppArmor"
    if [ "$os_vendor" = "SuSE" ]; then 
      check_file="/boot/grub/menu.lst"
      do_test=1
    fi
    if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 16 ]; then
      check_file="/boot/grub/grub.cfg"
      do_test=1
    fi
    if [ "$do_test" = 1 ]; then
      verbose_message "$app_name"
      check_linux_package install $package_name
      if [ "$audit_mode" = 2 ]; then
        restore_file $check_file $restore_dir
      else
        if [ -f "$check_file" ]; then
          armor_test=$( grep "$package_name=0" $check_file | head -1 | wc -l )
        else
          armor_test=0
        fi
        if [ "$armor_test" = "1" ]; then
          increment_insecure "$app_name is not enabled"
          temp_file="$temp_dir/$package_name"
          backup_file $check_file
          lockdown_command "cat $check_file |sed 's/$package_name=0//g' > $temp_file ; cat $temp_file > $check_file ; enforce /etc/$package_name.d/*" "Enabling $app_name"
        else
          increment_secure "$app_name enabled"
        fi
      fi
    fi
  fi
}
