# audit_remote_consoles
#
# Refer to Section(s) 9.1 Page(s) 72  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.1 Page(s) 116 CIS Solaris 10 Benchmark v5.1.0
#.

audit_remote_consoles () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Remote Consoles"
    log_file="remoteconsoles.log"
    if [ "$audit_mode" != 2 ]; then
      disable_ttys=0
      echo "Checking:  Remote consoles"
      log_file="$work_dir/$log_file"
      for console_device in `/usr/sbin/consadm -p`; do
        total=`expr $total + 1`
        disable_ttys=1
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Console enabled on $console_device [$insecure Warnings]"
          verbose_message "" fix
          verbose_message "consadm -d $console_device" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "$console_device" >> $log_file
          echo "Setting:   Console disabled on $console_device"
          consadm -d $console_device
        fi
      done
      if [ "$disable_ttys" = 0 ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    No remote consoles enabled [$secure Passes]"
        fi
      fi
    else
      restore_file="$restore_dir$log_file"
      if [ -f "$restore_file" ]; then
        for console_device in `cat $restore_file`; do
          echo "Restoring: Console to enabled on $console_device"
          consadm -a $console_device
        done
      fi
    fi
  fi
}
