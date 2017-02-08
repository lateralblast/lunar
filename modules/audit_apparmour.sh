# audit_apparmour
#
# Refer to Section(s) 4.5     Page(s) 38-9  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.6.2.1 Page(s) 69-70 CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.6.3   Page(s) 73-4  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_apparmour () {
  if [ "$os_name" = "Linux" ]; then
    do_test=0
    if [ "$os_vendor" = "SuSE" ]; then 
      do_test=1
    fi
    if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 16 ]; then
      do_test=1
    fi
    if [ "$do_test" = 1 ]; then
      funct_verbose_message "AppArmour"
      funct_linux_package install apparmour
      check_file="/boot/grub/menu.lst"
      if [ "$audit_mode" = 2 ]; then
        funct_restore_file $check_file $restore_dir
      else
        if [ -f "$check_file" ]; then
          armour_test=`cat $check_file |grep "apparmour=0" |head -1 |wc -l`
        else
          armour_test=0
        fi
        total=`expr $total + 1`
        if [ "$armour_test" = "1" ]; then
          if [ ! -f "check_shell" ]; then
            if [ "$audit_mode" = 1 ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   AppArmour is not enabled [$insecure Warnings]"
              funct_verbose_message "" fix
              funct_verbose_message "cat $check_file |sed 's/apparmour=0//g' > $temp_file" fix
              funct_verbose_message "cat $temp_file > $check_file" fix
              funct_verbose_message "enforce /etc/apparmor.d/*" fix
              funct_verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              temp_file="$temp_dir/apparmour"
              funct_backup_file $check_file
              cat $check_file |sed 's/apparmour=0//g' < $temp_file
              cat $temp_file > $check_file
              enforce /etc/apparmor.d/*
            fi
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Secure:    AppArmour enabled [$secure Passes]"
          fi
        fi
      fi
    fi
  fi
}
