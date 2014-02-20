# audit_kernel_accounting
#
# Kernel-level auditing provides information on commands and system calls that
# are executed on the local system. The audit trail may be reviewed with the
# praudit command. Note that enabling kernel-level auditing on Solaris disables
# the automatic mounting of external devices via the Solaris volume manager
# daemon (vold).
# Kernel-level auditing can consume a large amount of disk space and even cause
# system performance impact, particularly on heavily used machines.
#.

audit_kernel_accounting () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      check_file="/etc/system"
      if [ -f "$check_file" ]; then
        funct_verbose_message "Kernel and Process Accounting"
        check_acc=`cat $check_file |grep -v '^*' |grep 'c2audit:audit_load'`
        if [ `expr "$check_acc" : "[A-z]"` != 1 ]; then
          funct_file_value $check_file c2audit colon audit_load star
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
        funct_file_value $check_file flags colon "lo,ad,cc" hash
        funct_file_value $check_file naflags colon "lo,ad,ex" hash
        funct_file_value $check_file minfree colon 20 hash
        check_file="/etc/security/audit_user"
        funct_file_value $check_file root colon "lo,ad:no" hash
      fi
    fi
  fi
}
