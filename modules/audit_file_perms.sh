# audit_file_perms
#
# It is important to ensure that system files and directories are maintained
# with the permissions they were intended to have from the OS vendor (Oracle).
#.

audit_file_perms () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "System File Permissions"
    log_file="fileperms.log"
    if [ "$audit_mode" != 2 ]; then
      if [ "$os_version" = "11" ]; then
        error=0
        command=$( pkg verify | grep file | awk '{print $2}' )
      else
        command=$( pkgchk -n 2>&1 |grep ERROR | awk '{print $2}' )
      fi
      for check_file in $command; do
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Incorrect permissions on $check_file"
        fi
        if [ "$audit_mode" = 0 ]; then
          if [ "$os_version" = "10" ]; then
            verbose_message "Setting:   Correct permissions on $check_file"
            log_file="$work_dir/$log_file"
            file_perms=$( ls -l $check_file | echo "obase=8;ibase=2;\`awk '{print $1}' | cut -c2-10 | tr 'xrws-' '11110'\`" | /usr/bin/bc )
            file_owner=$( ls -l $check_file | awk '{print $3","$4}' )
            echo "$check_file,$file_perms,$file_owner" >> $log_file
            pkgchk -f -n -p $file_name 2> /dev/null
          else
            error=1
          fi
        fi
      done
      if [ "$os_version" = "11" ]; then
        if [ "$audit_mode" = 0 ]; then
          if [ "$error" = 1 ]; then
            log_file="$work_dir/$log_file"
            file_perms=$( ls -l $check_file | echo "obase=8;ibase=2;\`awk '{print $1}' | cut -c2-10 | tr 'xrws-' '11110'\`" | /usr/bin/bc )
            file_owner=$( ls -l $check_file | awk '{print $3","$4}' )
            echo "$check_file,$file_perms,$file_owner" >> $log_file
            pkg fix
          fi
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        restore_check=$( cat $restore_file | grep "$check_file" | cut -f1 -d"," )
        if [ "$restore_check" = "$check_file" ]; then
          restore_info=$( cat $restore_file | grep "$check_file" )
          restore_perms=$( echo "$restore_info" | cut -f2 -d"," )
          restore_owner=$( echo "$restore_info" | cut -f3 -d"," )
          restore_group=$( echo "$restore_info" | cut -f4 -d"," )
          verbose_message "Restoring: File $check_file to previous permissions"
          chmod $restore_perms $check_file
          if [ "$check_owner" != "" ]; then
            chown $restore_owner:$restore_group $check_file
          fi
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    verbose_message "System File Permissions"
    log_file="fileperms.log"
    if [ "$audit_mode" != 2 ]; then
      verbose_message "File permissions [This may take a while]"

      # Check specific to Debian
      if [ "$os_vendor" = "Ubuntu" ] || [ "$os_vendor" = "Debian" ]; then
        # TODO
        echo ""
      fi

      # Check specific to Red Hat/CentOS
      if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
        for check_file in $( rpm -Va --nomtime --nosize --nomd5 --nolinkt | awk '{print $2}' ); do
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Incorrect permissions on $file_name"
            verbose_message "" fix
            verbose_message "yum reinstall $rpm_name" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   Correct permissions on $file_name"
            log_file="$work_dir/$log_file"
            file_perms=$( stat -c %a $check_file )
            file_owner=$( ls -l $check_file | awk '{print $3","$4}' )
            echo "$check_file,$file_perms,$file_owner" >> $log_file
            yum reinstall $rpm_name
          fi
        done
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        restore_check=$( cat $restore_file | grep "$check_file" | cut -f1 -d"," )
        if [ "$restore_check" = "$check_file" ]; then
          restore_info=$( cat $restore_file | grep "$check_file" )
          restore_perms=$( echo "$restore_info" | cut -f2 -d"," )
          restore_owner=$( echo "$restore_info" | cut -f3 -d"," )
          restore_group=$( echo "$restore_info" | cut -f4 -d"," )
          verbose_message "Restoring: File $check_file to previous permissions"
          chmod $restore_perms $check_file
          if [ "$check_owner" != "" ]; then
            chown $restore_owner:$restore_group $check_file
          fi
        fi
      fi
    fi
  fi
}
