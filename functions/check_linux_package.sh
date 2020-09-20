# check_linux_package
#
# Check package
# Takes the following variables:
# package_mode:   Mode, eg check install uninstall restore
# package_check:  Package to check for
#.

check_linux_package () {
  if [ "$os_name" = "Linux" ]; then
    package_mode=$1
    package_check=$2
    group_check=$3
    package_type="Package"
    if [ "$package_mode" = "install" ]; then
      package_status="installed"
      package_state="present"
    else
      package_status="uninstalled"
      package_state="absent"
    fi
    log_file="package_log"
    backup_file="$work_dir/$log_file"
    if [ "$audit_mode" != "2" ]; then
      string="$package_type $package_check is $package_status"
      verbose_message "$string"
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: $string"
        echo "  package:"
        echo "    name: $package_check"
        echo "    state: $package_state"
        echo ""
      fi
      if [ "$linux_dist" = "debian" ]; then
        package_name=$( dpkg -l $package_check 2>&1 | grep $package_check | awk '{print $2}' )
      else
        if [ "$group_check" ]; then
          package_type="Group"
          package_name=$( yum grouplist 2>&1 | grep "$package_check" | sed "s/^   //g" )
        else
          package_name=$( rpm -qi $package_check | grep '^Name' | awk '{print $3}' )
        fi
      fi
      if [ "$package_mode" = "install" ] && [ "$package_name" = "$package_check" ]; then
        increment_secure "$package_type $package_check is $package_status"
      else
        if [ "$package_mode" = "uninstall" ] && [ "$package_name" != "$package_check" ] || [ "$package_name" = "" ]; then
          increment_secure "$package_type $package_check is $package_status"
        else
          increment_insecure "$package_type $package_check is not $package_status"
        fi
      fi
      if [ "$package_mode" = "install" ]; then
        if [ "$linux_dist" = "redhat" ]; then
          if [ "$group_check" ]; then
            package_command="yum -y groupinstall \"$package_check\""
          else
            package_command="yum -y install $package_check"
          fi
        fi
        if [ "$linux_dist" = "suse" ]; then
          package_command="zypper install $package_check"
        fi
        if [ "$linux_dist" = "debian" ]; then
          package_command="apt-get install $package_check"
        fi
        if [ "$package_check" = "aide" ]; then
          /usr/sbin/aide --init -B 'database_out=file:/var/lib/aide/aide.db.gz'
        fi
      fi
      if [ "$package_mode" = "uninstall" ]; then
        if [ "$linux_dist" = "redhat" ]; then
          if [ "$group_check" ]; then
            package_command="yum -y groupremove \"$package_check\""
          else
            package_command="rpm -e $package_check"
          fi
        fi
        if [ "$linux_dist" = "suse" ]; then
          package_command="zypper remove $package_check"
        fi
        if [ "$linux_dist" = "debian" ]; then
          package_command="apt-get purge $package_check"
        fi
      fi
      if [ "$audit_mode" = "0" ] && [ "$package_mode" != "check" ]; then
        if [ "$package_uninstall" = "yes" ]; then
          echo "$package_check,$package_mode" >> $backup_file
          $( $package_command )
        else
          increment_insecure "Not uninstalling package as package uninstall has been set to no"
          verbose_message "" fix
          verbose_message "$command" fix
          verbose_message "" fix
        fi
      else
        verbose_message "" fix
        verbose_message "$command" fix
        verbose_message "" fix
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        restore_check=$( grep $package_check $restore_file | awk '{print $2}' )
        if [ "$restore_check" = "$package_check" ]; then
          package_action=$( grep $package_check $restore_file | awk '{print $1}' )
          verbose_message "Restoring: Package $package_action to $package_action"
          if [ "$package_action" = "install" ]; then
            if [ "$linux_dist" = "redhat" ]; then
              if [ "$group_check" ]; then
                yum groupremove "$package_check"
              else
                rpm -e $package_check
              fi
            fi
            if [ "$linux_dist" = "debian" ]; then
              apt-get purge $package_check
            fi
            if [ "$linux_dist" = "suse" ]; then
              zypper remove $package_check
            fi
          else
            if [ "$linux_dist" = "redhat" ]; then
              if [ "$group_check" ]; then
                yum groupinstall "$package_check"
              else
                yum -y install $package_check
              fi
            fi
            if [ "$linux_dist" = "debian" ]; then
              apt-get install $package_check
            fi
            if [ "$linux_dist" = "suse" ]; then
              zypper install $package_check
            fi
          fi
        fi
      fi
    fi
  fi
}
