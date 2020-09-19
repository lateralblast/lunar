# audit_root_ssh_keys
#
# Make sure there are not ssh keys for root
#.

audit_root_ssh_keys () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    verbose_message "Root SSH keys"
    if [ "$audit_mode" != 2 ]; then
      root_home=$( grep '^root' /etc/passwd | cut -f6 -d: )
      for check_file in $root_home/.ssh/authorized_keys $root_home/.ssh/authorized_keys2; do
        if [ "$audit_home" != 2 ]; then
          if [ -f "$check_file" ]; then
            if [ "$( wc -l $check_file | awk '{print $1}' )" -ge 1 ]; then
              if [ "$audit_mode" = 1 ]; then
                increment_insecure "Keys file $check_file exists"
                verbose_message "mv $check_file $check_file.disabled" fix
              fi
              if [ "$audit_mode" = 0 ]; then
                backup_file $check_file
                echo "Removing:  Keys file $check_file"
              fi
            else
              if [ "$audit_mode" = 1 ]; then
                increment_secure "Keys file $check_file does not contain any keys"
              fi
            fi
          else
            if [ "$audit_mode" = 1 ]; then
              increment_secure "Keys file $check_file does not exist"
            fi
          fi
        else
          restore_file $check_file $restore_dir
        fi
      done
    fi
  fi
}
