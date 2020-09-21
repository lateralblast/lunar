# audit_pam_rhosts
#
# Refer to Section(s) 6.8 Page(s) 51-52 CIS Solaris 11.1 Benchmark  v1.0.0
# Refer to Section(s) 6.4 Page(s) 89    CIS Solaris 10 Benchmark v5.1.0
#.

audit_pam_rhosts () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    string="PAM RHosts Configuration"
    verbose_message "$string"
    if [ "$os_name" = "SunOS" ]; then
      check_file="/etc/pam.conf"
      if [ "$audit_mode" = 2 ]; then
        restore_file $check_file $restore_dir
      else
        if [ -f "$check_file" ]; then
          pam_check=$( grep -v "^#" $check_file | grep "pam_rhosts_auth" | head -1 | wc -l )
          if [ "$ansible" = 1 ]; then
            echo ""
            echo "- name: Checking $string"
            echo "  command:  sh -c \"cat $check_file | grep -v '^#' |grep 'pam_rhosts_auth' |head -1 |wc -l\""
            echo "  register: pam_rhosts_auth_check"
            echo "  failed_when: pam_rhosts_auth_check == 1"
            echo "  changed_when: false"
            echo "  ignore_errors: true"
            echo "  when: ansible_facts['ansible_system'] == '$os_name'"
            echo ""
            echo "- name: Fixing $string"
            echo "  command: sh -c \"sed -i 's/^.*pam_rhosts_auth/#&/' $check_file\""
            echo "  when: pam_rhosts_auth_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
            echo ""
          fi
          if [ "$pam_check" = "1" ]; then
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "Rhost authentication enabled in $check_file"
              verbose_message "" fix
              verbose_message "sed -e 's/^.*pam_rhosts_auth/#&/' < $check_file > $temp_file" fix
              verbose_message "cat $temp_file > $check_file" fix
              verbose_message "rm $temp_file" fix
              verbose_message "" fix
            else
              log_file="$work_dir$check_file"
              if [ ! -f "$log_file" ]; then
                verbose_message "Saving:    File $check_file to $work_dir$check_file"
                find $check_file | cpio -pdm $work_dir 2> /dev/null
              fi
              echo "Setting:   Rhost authentication to disabled in $check_file"
              sed -e 's/^.*pam_rhosts_auth/#&/' < $check_file > $temp_file
              cat $temp_file > $check_file
              rm $temp_file
              if [ "$os_version" != "11" ]; then
                pkgchk -f -n -p $check_file 2> /dev/null
              else
                pkg fix $( pkg search $check_file | grep pkg | awk '{print $4}' )
              fi
            fi
          else
            increment_secure "Rhost authentication disabled in $check_file"
          fi
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_dir="/etc/pam.d"
      if [ -d "$check_dir" ]; then
        for check_file in $( ls $check_dir/* ); do
          if [ "$audit_mode" = 2 ]; then
            restore_file $check_file $restore_dir
          else
            pam_check=$( grep -v "^#" $check_file | grep "rhosts_auth" | head -1 | wc -l )
            if [ "$ansible" = 1 ]; then
              echo ""
              echo "- name: Checking $string"
              echo "  command:  sh -c \"cat $check_file | grep -v '^#' |grep 'rhosts_auth' |head -1 |wc -l\""
              echo "  register: pam_rhosts_auth_check"
              echo "  failed_when: pam_rhosts_auth_check == 1"
              echo "  changed_when: false"
              echo "  ignore_errors: true"
              echo "  when: ansible_facts['ansible_system'] == '$os_name'"
              echo ""
              echo "- name: Fixing $string"
              echo "  command: sh -c \"sed -i 's/^.*rhosts_auth/#&/' $check_file\""
              echo "  when: pam_rhosts_auth_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
              echo ""
            fi
            if [ "$pam_check" = "1" ]; then
              if [ "$audit_mode" = 1 ]; then
                increment_insecure "Rhost authentication enabled in $check_file"
                verbose_message "" fix
                verbose_message "sed -e 's/^.*rhosts_auth/#&/' < $check_file > $temp_file" fix
                verbose_message "cat $temp_file > $check_file" fix
                verbose_message "rm $temp_file" fix
                verbose_message "" fix
              fi
              if [ "$audit_mode" = 0 ]; then
                backup_file $check_file
                verbose_message "Setting:   Rhost authentication to disabled in $check_file"
                sed -e 's/^.*rhosts_auth/#&/' < $check_file > $temp_file
                cat $temp_file > $check_file
                rm $temp_file
              fi
            else
              increment_secure "Rhost authentication disabled in $check_file"
            fi
          fi
        done
      fi
    fi
  fi
}
