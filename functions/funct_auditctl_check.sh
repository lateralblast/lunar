# funct_auditctl_check
#
# Check whether a executable, file or directory is being audited
#.

funct_auditctl_check () {
  if [ $os_name = "Linux" ]; then
    check_file=$1
    if [ -e "$check_file" ]; then
      total=`expr $total + 1`
      check=`auditctl -l | grep $check_file`
      if [ ! "$check" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Use of $check_file not being audited [$insecure Warnings]"
      else
        secure=`expr $secure + 1`
        echo "Secure:    Use of $check_file is being audited [$secure Passes]"
      fi
    fi
  fi
}
