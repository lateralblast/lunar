# audit_linux_package
#
# Check package
# Takes the following variables:
# package_mode:   Mode, eg check install uninstall restore
# package_check:  Package to check for
# restore_file:   Restore file to check
#.

audit_linux_package () {
  if [ "$os_name" = "Linux" ]; then
    package_mode=$1
    package_check=$2
    restore_file=$3
    if [ "$os_name" = "Linux" ]; then
      if [ "$package_mode" = "check" ]; then
        if [ "$linux_dist" = "debian" ]; then
          package_name=`dpkg -l $package_check 2>1 |grep $package_check |awk '{print $2}'`
        else
          package_name=`rpm -qi $package_check |grep '^Name' |awk '{print $3}'`
        fi
      fi
      if [ "$package_mode" = "install" ]; then
        if [ "$linux_dist" = "redhat" ]; then
          yum -y install $package_check
        fi
        if [ "$linux_dist" = "suse" ]; then
          zypper install $package_check
        fi
        if [ "$linux_dist" = "debian" ]; then
          apt-get install $package_check
        fi
        if [ "$package_check" = "aide" ]; then
          /usr/sbin/aide --init -B 'database_out=file:/var/lib/aide/aide.db.gz'
        fi
      fi
      if [ "$package_mode" = "uninstall" ]; then
        if [ "$linux_dist" = "redhat" ]; then
          rpm -e $package_check
        fi
        if [ "$linux_dist" = "suse" ]; then
          zypper remove $package_check
        fi
        if [ "$linux_dist" = "debian" ]; then
          apt-get purge $package_check
        fi
      fi
      if [ "$package_mode" = "restore" ]; then
        if [ -f "$restore_file" ]; then
          restore_check=`cat $restore_file |grep $package_check |awk '{print $2}'`
          if [ "$restore_check" = "$package_check" ]; then
            package_action=`cat $restore_file |grep $package_check |awk '{print $1}'`
            echo "Restoring: Package $package_action to $package_action"
            if [ "$package_action" = "Installed" ]; then
              if [ "$linux_dist" = "redhat" ]; then
                rpm -e $package_check
              fi
              if [ "$linux_dist" = "debian" ]; then
                apt-get purge $package_check
              fi
              if [ "$linux_dist" = "suse" ]; then
                zypper remove $package_check
              fi
            else
              if [ "$linux_dist" = "redhat" ]; then
                yum -y install $package_check
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
  fi
}
