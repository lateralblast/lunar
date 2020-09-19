# audit_pam_gdm_autologin
#
# Refer to Section(s) 16.11 Page(s) 54-5 Solaris 11.1 Benchmark v1.0.0
#.

audit_pam_gdm_autologin () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      string="Gnome Autologin"
      verbose_message "$string"
      check_file="/etc/pam.d/gdm-autologin"
      temp_file="$temp_dir/gdm-autologin"
      if [ "$audit_mode" = 2 ]; then
        restore_file $check_file $restore_dir
      fi
      if [ "$audit_mode" != 2 ]; then
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: Checking $string"
          echo "  command:  sh -c \"cat $check_file |grep -v '^#' |grep '^gdm-autologin' |head -1 |wc -l\""
          echo "  register: gdm_autologin_check"
          echo "  failed_when: gdm_autologin_check == 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '$os_name'"
          echo ""
          echo "- name: Fixing $string"
          echo "  command: sh -c \"sed -i 's/^gdm-autologin/#&/g' $check_file\""
          echo "  when: gdm_autologin_check .rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
          echo ""
        fi
        gdm_check=$( grep -v "^#" $check_file | grep "^gdm-autologin" | head -1 | wc -l )
        if [ "$gdm_check" != 0 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Gnome Autologin is enabled"
            verbose_message "" fix
            verbose_message "cat $check_file |sed 's/^gdm-autologin/#&/g' > $temp_file" fix
            verbose_message "cat $temp_file > $check_file" fix
            verbose_message "rm $temp_file" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            backup_file $check_file
            cat $check_file |sed 's/^gdm-autologin/#&/g' > $temp_file
            cat $temp_file > $check_file
            rm $temp_file
          fi
        else
          if [ "$audit_mode" = 1 ];then
            increment_secure "No members in shadow group"
          fi
        fi
      fi
    fi
  fi
}
