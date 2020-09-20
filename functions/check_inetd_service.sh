# check_inetd_service
#
# Change status of an inetd (/etc/inetd.conf) services
#
#.

check_inetd_service () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "SunOS" ]; then
    service_name=$1
    correct_status=$2
    check_file="/etc/inetd.conf"
    log_file="$service_name.log"
    if [ -f "$check_file" ]; then
      if [ "$correct_status" = "disabled" ]; then
        actual_status=$( grep '^$service_name' $check_file | grep -v '^#' | awk '{print $1}' )
      else
        actual_status=$( grep '^$service_name' $check_file | awk '{print $1}' )
      fi
      if [ "$audit_mode" != 2 ]; then
        string="If inetd service $service_name is set to $correct_status"
        verbose_message "$string"
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: $string"
          echo "  lineinfile:"
          echo "    path: $check_file"
          echo "    regexp: ''(.*$service_name.*)'"
          echo "    replace: '#\1'"
          echo "  when: ansible_facts['ansible_system'] == '$os_name' or ansible_facts['ansible_system'] == '$os_name'"
          echo ""
        fi
        if [ "$actual_status" != "" ]; then
          increment_insecure "Service $service_name does not have $parameter_name set to $correct_status"
          backup_file $check_file
          if [ "$correct_status" = "disable" ]; then
            disable_value $check_file $service_name hash
          else
            :
          fi
        else
          increment_secure "Service $service_name is set to $correct_status"
        fi
      else
        restore_file $check_file $restore_dir
      fi
    fi
  fi
}
