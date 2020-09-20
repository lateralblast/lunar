# audit_root_home
#
# Refer to Section(s) 7.5 Page(s) 105-6 CIS Solaris 10 Benchmark v5.1.0
#.

audit_root_home () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Home Directory Permissions for root Account"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        home_check=$( grep root /etc/passwd | cut -f6 -d: )
        log_file="$work_dir/roothome.log"
        if [ "$home_check" != "/root" ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Root home directory incorrectly set"
            verbose_message "" fix
            verbose_message "mkdir -m 700 /root" fix
            verbose_message "mv -i /.?* /root/" fix
            verbose_message "passmgmt -m -h /root root" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "$home_check" >> $log_file
            verbose_message "Setting:   Root home directory correctly"
            mkdir -m 700 /root
            mv -i /.?* /root/
            passmgmt -m -h /root root
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "Root home directory correctly set"
          fi
        fi
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/rootgroup.log"
          if [ -f "$restore_file" ]; then
            $home_check=$( cat $restore_file )
            verbose_message "Restoring: Root home directory $home_check"
            mv -i $home_check/.?* /
            passmgmt -m -h $group_check root
          fi
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    check_file_perms /root 0700 root root
  fi
}
