# audit_solaris_auditing
#
# Check auditing setup on Solaris 11
# Need to investigate more auditing capabilities on Solaris 10
#.

audit_solaris_auditing () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      verbose_message "Solaris Auditing"
      check_command_output getcond
      check_command_output getpolicy
      check_command_output getnaflags
      check_command_output getplugin
      check_command_output userattr
      if [ "$audit_mode" != 1 ]; then
        audit -s
      fi
      check_file="/var/spool/cron/crontabs/root"
      if [ "$audit_mode" = 0 ]; then
        log_file="$workdir$check_file"
        rolemod -K audit_flags=lo,ad,ft,ex,lck:no root
        if [ -f "$check_file" ]; then
          audit_check=$( grep "audit -n" $check_file | cut -f4 -d'/' )
          if [ "$audit_check" != "audit -n" ]; then
            if [ ! -f "$log_file" ]; then
              verbose_message "Saving:    File $check_file to $work_dir$check_file"
              find $check_file | cpio -pdm $work_dir 2> /dev/null
            fi
            echo "0 * * * * /usr/sbin/audit -n" >> $check_file
            chown root:root /var/audit
            chmod 750 /var/audit
            pkg fix $( pkg search $check_file |grep pkg |awk '{print $4}' )
          fi
        fi
      fi
    fi
  fi
}
