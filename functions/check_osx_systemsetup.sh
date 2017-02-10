# check_osx_systemsetup
#
# Function to systemsetup output under OS X
#.

check_osx_systemsetup () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_release" -ge 12 ]; then
      param=$1
      value=$2
      backup_file="systemsetup_$param"
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Parameter \"$param\" is set to \"$value\""
        check=`sudo systemsetup -$param |cut -f2 -d: |sed "s/ //g" |tr "[:upper:]" "[:lower:]"`
        if [ "$check" != "$value" ]; then
          increment_insecure "Parameter \"$param\" not set to \"$value\""
          backup_file="$work_dir/$backup_file"
          lockdown_command "echo \"$check\" > $backup_file ; sudo systemsetup -$param $value" "Parameter \"$param\" to \"$value\""
        else
          increment_secure "Parameter \"$param\" is set to \"$value\""
        fi
      else
        restore_file="$restore_dir/$backup_file"
        if [ -f "$restore_file" ]; then
          now=`sudo systemsetup -$param |cut -f2 -d: |sed "s/ //g" |tr "[:upper:]" "[:lower:]"`
          old=`cat $restore_file`
          if [ "$now" != "$old" ]; then
            echo "Setting:   Parameter $param back to $old"
            sudo systemsetup -$param $old
          fi
        fi
      fi
    fi
  fi
}
