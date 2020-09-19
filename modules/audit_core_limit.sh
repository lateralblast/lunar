# audit_core_limit
#
# Refer to Section(s) 2.10 Page(s) 34-35 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_core_limit () {
  if [ "$os_name" = "Darwin" ]; then
    string="Core dump limits"
    verbose_message "$string"
    log_file="corelimit"
    backup_file="$work_dir/$log_file"
    current_value=$( launchctl limit core | awk '{print $3}' )
    if [ "$audit_mode" != 2 ]; then
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  command:  sh -c \"launchctl limit core | awk '{print \$3}'\""
        echo "  register: corelimit_check"
        echo "  failed_when: corelimit_check == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '$os_name'"
        echo ""
        echo "- name: Fixing $string"
        echo "  command: sh -c \"launchctl limit core 0\""
        echo "  when: corelimit_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
        echo ""
      fi
      if [ "$current_value" != "0" ]; then
        if [ ! "$audit_mode" = 0 ]; then
          increment_insecure "Core dumps unlimited"
          verbose_message "" fix
          verbose_message "launchctl limit core 0" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          verbose_message "Setting:   Core dump limits"
          echo "$current_value" > $log_file
          launchctl limit core 0
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "Core dump limits exist"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        previous_value=$( cat $restore_file )
        if [ "$current_value" != "$previous_value" ]; then
          verbose_message "Restoring: Core limit to $previous_value"
          launchctl limit core unlimited
        fi
      fi
    fi
  fi
}
