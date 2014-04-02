# funct_dscl_check
#
# Function to check dscl output under OS X
#.

funct_dscl_check () {
  if [ "$os_name" = "Darwin" ]; then
    dscl_file=$1
    dscl_parameter=$2
    dscl_value=$3
    dscl_dir="/var/db/dslocal/nodes/Default"
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Parameter \"$dscl_parameter\" is set to \"$dscl_value\" in \"$dscl_file\""
      check_vale=`sudo dscl . -read $dscl_file $dscl_parameter`
      if [ "$check_value" != "$dscl_value" ]; then
        score=`expr $score - 1`
        echo "Warning:   Parameter \"$dscl_parameter\" not set to \"$dscl_value\" in \"$dscl_file\" [$score]"
        funct_verbose_message "" fix
        funct_verbose_message "sudo dscl . -create $dscl_file $dscl_parameter \"$dscl_value\"" fix
        funct_verbose_message "" fix
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $dscl_dir$dscl_file
          echo "Setting:   Parameter \"$dscl_parameter\" to \"$dscl_value\" in $dscl_file"
          sudo dscl . -create $dscl_file $dscl_parameter \"$dscl_value\"
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Parameter \"$dscl_parameter\" is set to \"$dscl_value\" in \"$dscl_file\" [$score]"
        fi
      fi
    else
      funct_restore_file $dscl_dir$dscl_file $restore_dir
    fi
  fi
}
