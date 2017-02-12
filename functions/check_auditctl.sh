# check_auditctl
#
# Check whether a executable, file or directory is being audited
#.

check_auditctl () {
  check_file=$1
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Auditing on file $check_file"
    if [ "$audit_mode" != 2 ]; then
      if [ -e "$check_file" ]; then
        check=`auditctl -l | grep $check_file`
        if [ ! "$check" ]; then
          increment_insecure "Use of $check_file not being audited"
        else
          increment_secure "Use of $check_file is being audited"
        fi
      fi
    fi
  fi
}
