# funct_command_output
#
# Code to test command output
#.

funct_command_output () {
  if [ "$os_name" = "SunOS" ]; then
    command_name=$1
    total=`expr $total + 1`
    if [ "$command_name" = "getcond" ]; then
      get_command="auditconfig -getcond |cut -f2 -d'=' |sed 's/ //g'"
    fi
    if [ "$command_name" = "getpolicy" ]; then
      get_command="auditconfig -getpolicy |head -1 |cut -f2 -d'=' |sed 's/ //g'"
      correct_value="argv,cnt,zonename"
      restore_command="auditconfig -setpolicy"
    fi
    if [ "$command_name" = "getnaflages" ]; then
      get_command="auditconfig -getpolicy |head -1 |cut -f2 -d'=' |sed 's/ //g' |cut -f1 -d'('"
      correct_value="lo"
      restore_command="auditconfig -setnaflags"
    fi
    if [ "$command_name" = "getflages" ]; then
      get_command="auditconfig -getflags |head -1 |cut -f2 -d'=' |sed 's/ //g' |cut -f1 -d'('"
      correct_value="lck,ex,aa,ua,as,ss,lo,ft"
      restore_command="auditconfig -setflags"
    fi
    if [ "$command_name" = "getplugin" ]; then
      get_command="auditconfig -getplugin audit_binfile |tail-1 |cut -f3 -d';'"
      correct_value="p_minfree=1"
      restore_command="auditconfig -setplugin audit_binfile active"
    fi
    if [ "$command_name" = "userattr" ]; then
      get_command="userattr audit_flags root"
      correct_value="lo,ad,ft,ex,lck:no"
      restore_command="auditconfig -setplugin audit_binfile active"
    fi
    if [ "$command_name" = "getcond" ]; then
      set_command="auditconfig -conf"
    else
      if [ "$command_name" = "getflags" ]; then
        set_command="$restore_command lo,ad,ft,ex,lck"
      else
        set_command="$restore_command $correct_value"
      fi
    fi
    log_file="$command_name.log"
    check_value=`$get_command`
    if [ "$audit_mode" = 1 ]; then
      if [ "$check_value" != "$correct_value" ]; then
        score=`expr $score - 1`
        echo "Warning:   Command $command_name does not return correct value [$score]"
      else
        score=`expr $score + 1`
        echo "Secure:    Command $command_name returns correct value [$score]"
      fi
    fi
    if [ "$audit_mode" = 0 ]; then
      log_file="$work_dir/$log_file"
      if [ "$check_value" != "$test_value" ]; then
        echo "Setting:   Command $command_name to correct value"
        $test_command > $log_file
        $set_command
      fi
    fi
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        echo "Restoring: Previous value for $command_name"
        if [ "$command_name" = "getcond" ]; then
          $restore_command
        else
          restore_string=`cat $restore_file`
          $restore_command $restore_string
        fi
      fi
    fi
  fi
}
