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
    if [ "$audit_mode" != 2 ]; then
      string="Parameter $defaults_parameter is set to $defaults_value in $defaults_file"
      handle_output "Checking:  $string"
      if [ "$defaults_host" = "currentHost" ]; then
        defaults_read="-currentHost $defaults_read"
        defaults_write="-currentHost $defaults_write"
        backup_file="~/Library/Preferences/ByHost/$defaults_file*"
        defaults_command="defaults"
      fi
      check_vale=$( $defaults_command $defaults_read $defaults_file $defaults_parameter 2>&1 )
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
        increment_insecure "Parameter \"$defaults_parameter\" not set to \"$defaults_value\" in \"$defaults_file\""
        verbose_message "" fix
        if [ "$defaults_value" = "" ]; then
          verbose_message "$defaults_command delete $defaults_file $defaults_parameter" fix
          command="$defaults_command delete $defaults_file $defaults_parameter"
        else
          if [ "$defaults_type" = "bool" ]; then
            verbose_message "$defaults_command write $defaults_file $defaults_parameter -bool \"$defaults_value\"" fix
            command="$defaults_command write $defaults_file $defaults_parameter -bool \"$defaults_value\""
          else
            if [ "$defaults_type" = "int" ]; then
              verbose_message "$defaults_command write $defaults_file $defaults_parameter -int $defaults_value" fix
              command="$defaults_command write $defaults_file $defaults_parameter -int $defaults_value"
            else
              if [ "$defaults_type" = "dict" ]; then
                if [ "$defaults_second_type" = "bool" ]; then
                  verbose_message "$defaults_command write $defaults_file $defaults_parameter -dict $defaults_value -bool $defaults_second_value" fix
                  command="$defaults_command write $defaults_file $defaults_parameter -dict $defaults_value -bool $defaults_second_value"
                else
                  if [ "$defaults_second_type" = "int" ]; then
                    verbose_message "$defaults_command write $defaults_file $defaults_parameter -dict $defaults_value -int $defaults_second_value" fix
                    command="$defaults_command write $defaults_file $defaults_parameter -dict $defaults_value -int $defaults_second_value"
                  fi
                fi
              else
                verbose_message "$defaults_command write $defaults_file $defaults_parameter \"$defaults_value\"" fix
                command="$defaults_command write $defaults_file $defaults_parameter \"$defaults_value\""
              fi
            fi
          fi
        fi
        verbose_message "" fix
        if [ "$audit_mode" = 0 ]; then
          backup_file "$backup_file"
         string="Parameter $defaults_parameter to $defaults_value in $defaults_file"
         verbose_message "Setting:   $string"
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
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: Checking $string"
          echo "  command: sh -c \"$defaults_command $defaults_read $defaults_file $defaults_parameter 2>&1 |grep $defaults_value\""
          echo "  register: defaults_check"
          echo "  failed_when: defaults_check == 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '$os_name'"
          echo ""
          echo "- name: Fixing $string"
          echo "  command: sh -c \"$command\""
          echo "  when: defaults_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
          echo ""
        fi
      else
        increment_secure "Parameter \"$defaults_parameter\" is set to \"$defaults_value\" in \"$defaults_file\""
      fi
    else
      restore_file $backup_file $restore_dir
    fi
  fi
}
