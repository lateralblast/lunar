# audit_dot_files
#
# Check for a dot file and copy it to backup directory
#.

audit_dot_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Dot Files"
    check_file=$1
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  For $check_file files"
      for dir_name in `cat /etc/passwd |cut -f6 -d':'`; do
        if [ "$dir_name" = "/" ]; then
          dot_file="/$check_file"
        else
          dot_file="$dir_name/$check_file"
        fi
        if [ -f "$dot_file" ]; then
          if [ "$audit_mode" = 1 ];then
            total=`expr $total + 1`
            insecure=`expr $insecure + 1`
            echo "Warning:   File $dot_file exists [$insecure Warnings]"
            funct_verbose_message "mv $dot_file $dot_file.disabled" fix
          fi
          if [ "$audit_mode" = 0 ];then
            funct_backup_file $dot_file
          fi
        else
          if [ "$audit_mode" = 1 ];then
            total=`expr $total + 1`
            secure=`expr $secure + 1`
            echo "Secure:    File $dot_file does not exist [$secure Passes]"
          fi
        fi
      done
    else
      for check_file in `cd $restore_dir ; find . -name "$check_file" |sed "s/^\.//g"`; do
        funct_restore_file $check_file $restore_dir
      done
    fi
  fi
}
