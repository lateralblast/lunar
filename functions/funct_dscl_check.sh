# funct_dscl_check
#
# Function to check dscl output under OS X
#.

funct_dscl_check () {
  if [ "$os_name" = "Darwin" ]; then
    file=$1
    parameter=$2
    value=$3
    dir="/var/db/dslocal/nodes/Default"
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Parameter \"$param\" is set to \"$value\" in \"$file\""
      check=`sudo dscl . -read $file $param`
      if [ "$check" != "$value" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Parameter \"$param\" not set to \"$value\" in \"$file\" [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "sudo dscl . -create $file $param \"$value\"" fix
        funct_verbose_message "" fix
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $dir$file
          echo "Setting:   Parameter \"$param\" to \"$value\" in $file"
          sudo dscl . -create $file $param \"$value\"
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Parameter \"$param\" is set to \"$value\" in \"$file\" [$secure Passes]"
        fi
      fi
    else
      funct_restore_file $dir$file $restore_dir
    fi
  fi
}
