# audit_grub_security
#
# Refer to Section(s) 1.5.3 Page(s) 47-8 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.1 Page(s) 57   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.4.1 Page(s) 52   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 3.1   Page(s) 31-2 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.4.1 Page(s) 50   CIS Amazon Linux Benchmark v2.0.0
#.

audit_grub_security () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Grub Menu Security"
    if [ "$os_name" = "Linux" ]; then
      for check_file in /etc/grub.conf /boot/grub/grub.cfg /boot/grub/menu.list; do
        check_file_perms $check_file 0600 root root
      done
      check_file="/boot/grub/grub.cfg"
      check_file_value is $check_file "set superusers" eq root hash
      check_file_value is $check_file "password_pbkdf2" space root hash
      check_file_value is $check_file "selinux" eq 1 hash
      check_file_value is $check_file "enforcing" eq 1 hash
      check_file="/etc/default/grub"
      check_file_value in $check_file "audit" eq 1 hash
    fi
#  if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
#    check_file="/boot/grub/menu.lst"
#    grub_check=`cat $check_file |grep "^password --md5" |awk '{print $1}'`
#    if [ "$grub_check" != "password" ]; then
#      if [ "$audit_mode" = 1 ]; then
#        
#        increment_insecure "Grub password not set"
#      fi
#      This code needs work
#      if [ "$audit_mode" = 0 ]; then
#        echo "Setting:   Grub password"
#        if [ ! -f "$log_file" ]; then
#          echo "Saving:    File $check_file to $log_file"
#          find $check_file | cpio -pdm $work_dir 2> /dev/null
#        fi
#   echo -n "Enter password: "
#   read $password_string
#   password_string=`htpasswd -nb test $password_string |cut -f2 -d":"`
#   echo "password --md5 $password_string" >> $check_file
#   chmod 600 $check_file
#   lock_check=`cat $check_file |grep lock`
#   if [ "$lock_check" != "lock" ]; then
#     cat $check_file |sed 's,Solaris failsafe,Solaris failsafe\
#Lock,g' >> $temp_file
#     cp $temp_file $check_file
#     rm $temp_file
#   fi
#     fi
#    else
#      if [ "$audit_mode" = 1 ]; then
#        
#        increment_secure "Set-UID not restricted on user mounted devices"
#      fi
#      if [ "$audit_mode" = 2 ]; then
#        restore_file="$restore_dir$check_file"
#        if [ -f "$restore_file" ]; then
#          echo "Restoring:  $restore_file to $check_file"
#          cp -p $restore_file $check_file
#          if [ "$os_version" = "10" ]; then
#            pkgchk -f -n -p $check_file 2> /dev/null
#          else
#            pkg fix `pkg search $check_file |grep pkg |awk '{print $4}'`
#          fi
#        fi
#      fi
#    fi
#  fi
  fi
}
