# audit_root_home
#
# By default, the Solaris OS root user's home directory is "/".
# Changing the home directory for the root account provides segregation from
# the OS distribution and activities performed by the root user. A further
# benefit is that the root home directory can have more restricted permissions,
# preventing viewing of the root system account files by non-root users.
#.

audit_root_home () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Home Directory Permissions for root Account"
    total=`expr $total + 1`
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        if [ "$audit_mode" != 2 ]; then
          echo "Checking:  Root home directory"
        fi
        home_check=`grep root /etc/passwd | cut -f6 -d:`
        log_file="$work_dir/roothome.log"
        if [ "$home_check" != "/root" ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Root home directory incorrectly set [$score]"
            funct_verbose_message "" fix
            funct_verbose_message "mkdir -m 700 /root" fix
            funct_verbose_message "mv -i /.?* /root/" fix
            funct_verbose_message "passmgmt -m -h /root root" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "$home_check" >> $log_file
            echo "Setting:   Root home directory correctly"
            mkdir -m 700 /root
            mv -i /.?* /root/
            passmgmt -m -h /root root
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    Root home directory correctly set [$score]"
          fi
        fi
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/rootgroup.log"
          if [ -f "$restore_file" ]; then
            $home_check=`cat $restore_file`
            echo "Restoring: Root home directory $home_check"
            mv -i $home_check/.?* /
            passmgmt -m -h $group_check root
          fi
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
      funct_check_perms /root 0700 root root
  fi
}
