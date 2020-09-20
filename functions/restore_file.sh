# restore_file
#
# Restore file
#
# This routine restores a file from the backup directory to its original
# As par of the restore it also restores the original permissions
#
# check_file      = The name of the original file
# restore_dir     = The directory to restore from
#.

restore_file () {
  check_file=$1
  check_dir=$2
  if [ "$audit_mode" = 2 ]; then
    if [ ! "$check_dir" ]; then
      restore_file="$restore_dir$check_file"
    else
      restore_file="$check_dir$check_file"
    fi
    if [ -f "$restore_file" ]; then
      sum_check_file=$( cksum $check_file |awk '{print $1}' )
      sum_restore_file=$( cksum $restore_file |awk '{print $1}' )
      if [ "$sum_check_file" != "$sum_restore_file" ]; then
        verbose_message "Restoring: File $restore_file to $check_file"
        cp -p $restore_file $check_file
        if [ "$os_name" = "SunOS" ]; then
          if [ "$os_version" != "11" ]; then
            pkgchk -f -n -p $check_file 2> /dev/null
          else
            pkg fix $( pkg search $check_file |grep pkg |awk '{print $4}' )
          fi
        fi
        if [ "$check_file" = "/etc/system" ]; then
          reboot=1
          verbose_message "Notice:    Reboot required"
        fi
        if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file" = "/etc/sshd_config" ]; then
          verbose_message "Notice:    Service restart required"
        fi
      fi
    fi
  fi
}
