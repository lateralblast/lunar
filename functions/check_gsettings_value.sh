# check_gsettings_value
#
# Audit gsettings values
#
# This routine takes the followinf values
#
# parameter_root  = The parameter root to be checked
# parameter_name  = The parameter name to be checked
# correct_value   = The value we expect to be returned
#
# If the current_value is not the correct_value then it is fixed if run in lockdown mode
# A copy of the value is stored in a log file, which can be restored
#.

check_gsettings_value () {
  parameter_root=$1
  parameter_name=$2 
  correct_value=$3
  command_name="gsettings"
  check=$( command -v gsettings 2> /dev/null )
  if [ "$check" ]; then
    set_command="gsettings set"
    get_command="gsettings get"
    if [ "$os_name" = "Linux" ]; then
      if [ "$audit_mode" = 2 ]; then
        restore_file="$restore_dir/$command_name.log"
        if [ -f "$restore_file" ]; then
          parameter_root=$( grep '$parameter_name' $restore_file | cut -f1 -d',' )
          parameter_name=$( grep '$parameter_name' $restore_file | cut -f2 -d',' )
          correct_value=$( grep '$parameter_name' $restore_file | cut -f3 -d',' )
          if [ $( expr "$parameter_name" : "[A-z]" ) = 1 ]; then
            verbose_message "Returning $parameter_name to $correct_value"
            $set_command $parameter_root $parameter_name "$correct_value" 
          fi
        fi
      else
        current_value=`gsettings get $parameter_root $parameter_name` 
        if [ "$current_value" = "$correct_value" ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Parameter \"$parameter_name\" is not set to \"$correct_value\" in $parameter_root"
            string="Parameter $parameter_root.$parameter_name to $correct_value"
            if [ "$ansible" = 1 ]; then
              echo ""
              echo "- name: $string"
              echo "  gsetting:"
              echo "    $parameter_root.$parameter_name: $correct_value"
              echo ""
            fi
            verbose_message "" fix
            verbose_message "$set_command $parameter_root $parameter_name \"$correct_value\"" fix
            verbose_message "" fix
          else
            if [ "$audit_mode" = 0 ]; then
              log_file="$restore_dir/$command_name.log"
              verbose_message "Setting:   $parameter_name to $correct_value"
              echo "$parameter_root,$parameter_name,$current_value" >> $log_file
              $set_command $parameter_root $parameter_name "$correct_value"
            fi
          fi
        fi
      fi 
    fi
  fi
}