# audit_kernel_accounting
#
# Refer to Section(s) 3.3 Page(s) 38-39 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section(s) 3.3 Page(s) 92    CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 4.9 Page(s) 73-5  CIS Solaris 10 Benchmark v5.1.0
#.

audit_kernel_accounting () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Darwin" ]; then
    check_file="/etc/system"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        if [ -f "$check_file" ]; then
          verbose_message "Kernel and Process Accounting"
          check_acc=$( grep -v '^*' $check_file | grep 'c2audit:audit_load' )
          if [ $( expr "$check_acc" : "[A-z]" ) != 1 ]; then
            check_file_value is $check_file c2audit colon audit_load star
            if [ "$audit_mode" = 0 ]; then
              log_file="$work_dir/bsmconv.log"
              echo "y" >> $log_file
              echo "y" | /etc/security/bsmconv
            fi
          fi
          if [ "$audit_mode" = 2 ]; then
            restore_file="$restore_dir/bsmconv.log"
            if [ -f "$restore_file" ]; then
              echo "y" | /etc/security/bsmunconv
            fi
          fi
          check_file="/etc/security/audit_control"
          check_file_value is $check_file flags colon "lo,ad,cc" hash
          check_file_value is $check_file naflags colon "lo,ad,ex" hash
          check_file_value is $check_file minfree colon 20 hash
          check_file="/etc/security/audit_user"
          check_file_value is $check_file root colon "lo,ad:no" hash
        fi
      fi
    else
      check_file="/etc/security/audit_control"
      check_file_value is $check_file flags colon "lo,ad,fd,fm,-all" hash
    fi
  fi
}
