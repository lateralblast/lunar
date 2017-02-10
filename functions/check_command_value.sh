# check_command_value
#
# Audit command output values
#
# Depending on the command_name send an appropriate check_command and set_command are set
# If the current_value is not the correct_value then it is fixed if run in lockdown mode
# A copy of the value is stored in a log file, which can be restored
#.

check_command_value () {
  command_name=$1
  parameter_name=$2
  correct_value=$3
  service_name=$4
  
  if [ "$audit_mode" = 2 ]; then
    restore_file="$restore_dir/$command_name.log"
    if [ -f "$restore_file" ]; then
      parameter_name=`cat $restore_file |grep '$parameter_name' |cut -f1 -d','`
      correct_value=`cat $restore_file |grep '$parameter_name' |cut -f2 -d','`
      if [ `expr "$parameter_name" : "[A-z]"` = 1 ]; then
        echo "Returning $parameter_name to $correct_value"
        if [ "$command_name" = "routeadm" ]; then
          if [ "$correct_value" = "disabled" ]; then
            set_command="routeadm -d"
          else
            set_command="routeadm -e"
          fi
          $set_command $parameter_name
        else
          $set_command $parameter_name $correct_value
          if [ `expr "$parameter_name" : "tcp_trace"` = 9 ]; then
            svcadm refresh svc:/network/inetd
          fi
        fi
      fi
    fi
  else
    if [ "$parameter_name" = "tcp_wrappers" ]; then
      echo "Checking:  Service $service_name has \"$parameter_name\" set to \"$correct_value\""
    else
      echo "Checking:  Output of $command_name \"$parameter_name\" is \"$correct_value\""
    fi
  fi
  if [ "$command_name" = "inetadm" ]; then
    check_command="inetadm -l $service_name"
    set_command="inetadm -m $service_name"
    current_value=`$check_command |grep "$parameter_name" |awk '{print $2}' |cut -f2 -d'='`
  fi
  if [ "$command_name" = "routeadm" ]; then
    check_command="routeadm -p $parameter_name"
    current_value=`$check_command |awk '{print $3}' |cut -f2 -d'='`
  fi
  log_file="$work_dir/$command_name.log"
  if [ "$current_value" != "$correct_value" ]; then
    if [ "$audit_mode" = 1 ]; then
      
      increment_insecure "Parameter \"$parameter_name\" not set to \"$correct_value\""
      if [ "$command_name" = "routeadm" ]; then
        if [ "$correct_value" = "disabled" ]; then
          set_command="routeadm -d"
        else
          set_command="routeadm -e"
        fi
        verbose_message "" fix
        verbose_message "$set_command $parameter_name" fix
        verbose_message "" fix
      else
        verbose_message "" fix
        verbose_message "$set_command $parameter_name=$correct_value" fix
        verbose_message "" fix
      fi
    else
      if [ "$audit_mode" = 0 ]; then
        echo "Setting:   $parameter_name to $correct_value"
        echo "$parameter_name,$current_value" >> $log_file
        if [ "$command_name" = "routeadm" ]; then
          if [ "$correct_value" = "disabled" ]; then
            set_command="routeadm -d"
          else
            set_command="routeadm -e"
          fi
          $set_command $parameter_name
        else
          $set_command $parameter_name=$correct_value
        fi
      fi
    fi
  else
    if [ "$audit_mode" != 2 ]; then
      if [ "$audit_mode" = 1 ]; then
        
        if [ "$parameter_name" = "tcp_wrappers" ]; then
          increment_secure "Service $service_name already has \"$parameter_name\" set to \"$correct_value\""
        else
          increment_secure "Output for command $command_name \"$parameter_name\" already set to \"$correct_value\""
        fi
      fi
    fi
  fi
}
