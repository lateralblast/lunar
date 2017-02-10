# check_dscl
#
# Function to check dscl output under OS X
#.

check_dscl () {
  if [ "$os_name" = "Darwin" ]; then
    file=$1
    parameter=$2
    value=$3
    dir="/var/db/dslocal/nodes/Default"
    
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Parameter \"$param\" is set to \"$value\" in \"$file\""
      check=`sudo dscl . -read $file $param`
      if [ "$check" != "$value" ]; then
        
        increment_insecure "Parameter \"$param\" not set to \"$value\" in \"$file\""
        verbose_message "" fix
        verbose_message "sudo dscl . -create $file $param \"$value\"" fix
        verbose_message "" fix
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $dir$file
          echo "Setting:   Parameter \"$param\" to \"$value\" in $file"
          sudo dscl . -create $file $param \"$value\"
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          
          increment_secure "Parameter \"$param\" is set to \"$value\" in \"$file\""
        fi
      fi
    else
      funct_restore_file $dir$file $restore_dir
    fi
  fi
}
