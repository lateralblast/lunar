# audit_apparmour
#
# AppArmor provides a Mandatory Access Control (MAC) system that greatly
# augments the default Discretionary Access Control (DAC) model.
# For an action to occur, both the traditional DAC permissions must be
# satisfied as well as the AppArmor MAC rules. The action will not be
# allowed if either one of these models does not permit the action.
# In this way, AppArmor rules can only make a system's permissions more
# restrictive and secure.
#
# Refer to Section(s) 4.5 Page(s) 38-9 SLES 11 Benchmark v1.0.0
#.

audit_apparmour () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "SuSE" ]; then
      funct_verbose_message "AppArmour"
      funct_linux_package install apparmour
      check_file="/boot/grub/menu.lst"
      if [ "$audit_mode" = 2 ]; then
        funct_restore_file $check_file $restore_dir
      else
        armour_test=`cat $check_file |grep "apparmour=0" |head -1 |wc -l`
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
