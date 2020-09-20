# check_command_output
#
# Code to test command output
#.

check_command_output () {
  if [ "$os_name" = "SunOS" ]; then
    command_name=$1
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
    check_value=$( $get_command )
    if [ "$audit_mode" != 2 ]; then
      string="Command $command_name returns $correct_value"
      verbose_message "Chaking:  $string"
       if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  command: sh -c \"$get_command |grep '$correct_value'\""
        echo "  register: lssec_check"
        echo "  failed_when: lssec_check == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '$os_name'"
        echo ""
        echo "- name: Fixing $string"
        echo "  command: sh -c \"$set_command\""
        echo "  when: lssec_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
        echo ""
      fi
      if [ "$check_value" != "$correct_value" ]; then
        increment_insecure "Command $command_name does not return correct value"
      else
        increment_secure "Command $command_name returns correct value"
      fi
      log_file="$work_dir/$log_file"
      lockdown_command "echo \"$restore_command\" > $log_file ; $set_command" "Command $command_name to correct value"
    fi
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        verbose_message "Restoring: Previous value for $command_name"
        if [ "$command_name" = "getcond" ]; then
          $restore_command
        else
          restore_string=$( cat $restore_file )
          $restore_command $restore_string
        fi
      fi
    fi
  fi
}
