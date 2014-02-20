# audit_solaris_auditing
#
# Check auditing setup on Solaris 11
# Need to investigate more auditing capabilities on Solaris 10
#.

audit_solaris_auditing () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      funct_verbose_message "Solaris Auditing"
      funct_command_output getcond
      funct_command_output getpolicy
      funct_command_output getnaflags
      funct_command_output getplugin
      funct_command_output userattr
      if [ "$audit_mode" != 1 ]; then
        audit -s
      fi
      check_file="/var/spool/cron/crontabs/root"
      if [ "$audit_mode" = 0 ]; then
        log_file="$workdir$check_file"
        rolemod -K audit_flags=lo,ad,ft,ex,lck:no root
        if [ -f "$check_file" ]; then
          audit_check=`cat $check_file |grep "audit -n" |cut -f4 -d'/'`
          if [ "$audit_check" != "audit -n" ]; then
            if [ ! -f "$log_file" ]; then
              echo "Saving:    File $check_file to $work_dir$check_file"
              find $check_file | cpio -pdm $work_dir 2> /dev/null
            fi
            echo "0 * * * * /usr/sbin/audit -n" >> $check_file
            chown root:root /var/audit
            chmod 750 /var/audit
            pkg fix `pkg search $check_file |grep pkg |awk '{print $4}'`
          fi
        fi
      fi
    fi
  fi
}
