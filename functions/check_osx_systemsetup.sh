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
      total=`expr $total + 1`
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Parameter \"$param\" is set to \"$value\""
        check=`sudo systemsetup -$param |cut -f2 -d: |sed "s/ //g" |tr "[:upper:]" "[:lower:]"`
        if [ "$check" != "$value" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Parameter \"$param\" not set to \"$value\" [$insecure Warnings]"
          verbose_message "" fix
          verbose_message "sudo systemsetup -$param $value" fix
          verbose_message "" fix
          if [ "$audit_mode" = 0 ]; then
            backup_file="$work_dir/$backup_file"
            echo $check > $backup_file
            echo "Setting:   Parameter \"$param\" to \"$value\""
            sudo systemsetup -$param $value
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Parameter \"$param\" is set to \"$value\" [$secure Passes]"
          fi
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
