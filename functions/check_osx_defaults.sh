# check_osx_defaults
#
# Function to check defaults under OS X
#.

check_osx_defaults () {
  if [ "$os_name" = "Darwin" ]; then
    defaults_file=$1
    defaults_parameter=$2
    defaults_value=$3
    defaults_type=$4
    if [ "$defaults_type" = "dict" ]; then
      defaults_second_value=$5
      defaults_second_type=$6
    else
      defaults_host=$5
    fi
    defaults_read="read"
    defaults_write="write"
    backup_file=$defaults_file
    defaults_command="sudo defaults"
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Parameter \"$defaults_parameter\" is set to \"$defaults_value\" in \"$defaults_file\""
      if [ "$defaults_host" = "currentHost" ]; then
        defaults_read="-currentHost $defaults_read"
        defaults_write="-currentHost $defaults_write"
        backup_file="~/Library/Preferences/ByHost/$defaults_file*"
        defaults_command="defaults"
      fi
      check_vale=`$defaults_command $defaults_read $defaults_file $defaults_parameter 2>&1`
      temp_value=defaults_value
      if [ "$defaults_type" = "bool" ]; then
        if [ "$defaults_value" = "no" ]; then
          temp_value=0
        fi
        if [ "$defaults_value" = "yes" ]; then
          temp_value=1
        fi
      fi
      if [ "$check_value" != "$temp_value" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Parameter \"$defaults_parameter\" not set to \"$defaults_value\" in \"$defaults_file\" [$insecure Warnings]"
        verbose_message "" fix
        verbose_message "$defaults_command write $defaults_file $defaults_parameter $defaults_value" fix
        if [ "$defaults_value" = "" ]; then
          verbose_message "$defaults_command delete $defaults_file $defaults_parameter" fix
        else
          verbose_message "$defaults_command write $defaults_file $defaults_parameter $defaults_value" fix
        fi
        verbose_message "" fix
        if [ "$audit_mode" = 0 ]; then
          backup_file "$backup_file"
          echo "Setting:   Parameter \"$defaults_parameter\" to \"$defaults_value\" in \"$defaults_file\""
          if [ "$defaults_value" = "" ]; then
            $defaults_command delete $defaults_file $defaults_parameter
          else
            if [ "$defaults_type" = "bool" ]; then
              $defaults_command write $defaults_file $defaults_parameter -bool "$defaults_value"
            else
              if [ "$defaults_type" = "int" ]; then
                $defaults_command write $defaults_file $defaults_parameter -int $defaults_value
                if [ "$defaults_file" ="/Library/Preferences/com.apple.Bluetooth" ]; then
                  killall -HUP blued
                fi
              else
                if [ "$defaults_type" = "dict" ]; then
                  if [ "$defaults_second_type" = "bool" ]; then
                    $defaults_command write $defaults_file $defaults_parameter -dict $defaults_value -bool $defaults_second_value
                  else
                    if [ "$defaults_second_type" = "int" ]; then
                      $defaults_command write $defaults_file $defaults_parameter -dict $defaults_value -int $defaults_second_value
                    fi
                  fi
                else
                  $defaults_command write $defaults_file $defaults_parameter "$defaults_value"
                fi
              fi
            fi
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Parameter \"$defaults_parameter\" is set to \"$defaults_value\" in \"$defaults_file\" [$secure Passes]"
        fi
      fi
    else
      restore_file $backup_file $restore_dir
    fi
  fi
}
