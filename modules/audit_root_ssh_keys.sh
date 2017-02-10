# audit_root_ssh_keys
#
# Make sure there are not ssh keys for root
#.

audit_root_ssh_keys () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    verbose_message "Root SSH keys"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Root SSH keys"
      root_home=`cat /etc/passwd |grep '^root' |cut -f6 -d:`
      for check_file in $root_home/.ssh/authorized_keys $root_home/.ssh/authorized_keys2; do
        total=`expr $total + 1`
        if [ "$audit_home" != 2 ]; then
          if [ -f "$check_file" ]; then
            if [ "`wc -l $check_file |awk '{print $1}'`" -ge 1 ]; then
              if [ "$audit_mode" = 1 ]; then
                total=`expr $total + 1`
                insecure=`expr $insecure + 1`
                echo "Warning:   Keys file $check_file exists [$insecure Warnings]"
                verbose_message "mv $check_file $check_file.disabled" fix
              fi
              if [ "$audit_mode" = 0 ]; then
                backup_file $check_file
                echo "Removing:  Keys file $check_file"
              fi
            else
              if [ "$audit_mode" = 1 ]; then
                total=`expr $total + 1`
                secure=`expr $secure + 1`
                echo "Secure:    Keys file $check_file does not contain any keys [$secure Passes]"
              fi
            fi
          else
            if [ "$audit_mode" = 1 ]; then
              total=`expr $total + 1`
              secure=`expr $secure + 1`
              echo "Secure:    Keys file $check_file does not exist [$secure Passes]"
            fi
          fi
        else
          restore_file $check_file $restore_dir
        fi
      done
    fi
  fi
}
