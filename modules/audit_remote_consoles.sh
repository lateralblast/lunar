# audit_remote_consoles
#
# The consadm command can be used to select or display alternate console devices.
# Since the system console has special properties to handle emergency situations,
# it is important to ensure that the console is in a physically secure location
# and that unauthorized consoles have not been defined. The "consadm -p" command
# displays any alternate consoles that have been defined as auxiliary across
# reboots. If no remote consoles have been defined, there will be no output from
# this command.
#
# Refer to Section(s) 9.1 Page(s) 72 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.1 Page(s) 116 CIS Solaris 10 v5.1.0
#.

audit_remote_consoles () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Remote Consoles"
    log_file="remoteconsoles.log"
    if [ "$audit_mode" != 2 ]; then
      disable_ttys=0
      echo "Checking:  Remote consoles"
      log_file="$work_dir/$log_file"
      for console_device in `/usr/sbin/consadm -p`; do
        total=`expr $total + 1`
        disable_ttys=1
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   Console enabled on $console_device [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "consadm -d $console_device" fix
          funct_verbose_message "" fix
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
          score=`expr $score + 1`
          echo "Secure:    No remote consoles enabled [$score]"
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
