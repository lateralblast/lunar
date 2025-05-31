#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_apparmor
#
# Check AppArmor
#
# Refer to Section(s) 4.5           Page(s) 38-9        CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.6.2.1,1.6.3 Page(s) 69-70,73-4  CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.3.1.1-2     Page(s) 151-4       CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_apparmor () {
  print_function "audit_apparmor"
  if [ "${os_name}" = "Linux" ]; then
    do_grub_test=0
    do_app_test=1
    package_name="apparmor"
    app_name="AppArmor"
    string="AppArmor Unconfined Applications"
    verbose_message "${string}" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    if [ "${os_vendor}" = "SuSE" ]; then 
      check_list="/boot/grub/menu.lst"
      do_test=1
    fi
    if [ "${os_vendor}" = "Ubuntu" ] && [ "${os_version}" -ge 16 ]; then
      check_list="/boot/grub/grub.cfg /etc/default/grub"
      do_grub_test=1
      do_app_test=1
    fi
    if [ "${do_app_test}" = 1 ]; then
      get_command="apparmor_status |grep \"unconfined mode\" |awk '{print \$1}'"
      set_command="sudo aa-enforce /etc/apparmor.d/*"
      profile_test=$( eval "${get_command}" )
      if [ "${profile_test}" = "0" ]; then
        increment_secure    "There are no unconfined applications"
      else
        increment_insecure  "There are unconfined applications"
      fi
      if [ "${ansible_mode}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="apparmor_check_${ansible_counter}"
        echo ""
        echo "- name: Checking ${string}"
        echo "  command: sh -c \"${get_command}\""
        echo "  register: ${ansible_value}"
        echo "  failed_when: ${ansible_value} != 0"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  command: sh -c \"${set_command}\""
        echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      else
        lockdown_command="${set_command}"
        lockdown_message="Confine AppArmor Applications"
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      fi
    fi
    for check_file in ${check_list}; do
      if [ "${do_grub_test}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        string="Package \"${app_name}\""
        ansible_value="apparmor_check_${ansible_counter}"
        verbose_message "${string}" "check"
        check_linux_package "install" "${package_name}"
        if [ "${audit_mode}" = 2 ]; then
          restore_file "${check_file}" "${restore_dir}"
        else
          if [ -f "${check_file}" ]; then
            disabled_get_command="grep '${package_name}=0' ${check_file} | head -1 | wc -l | sed 's/ //g'"
            package_disabled_test=$( grep "${package_name}=0" "${check_file}" | head -1 | wc -l | sed "s/ //g" )
            package_enabled_test=$( grep "${package_name}=1" "${check_file}" | head -1 | wc -l | sed "s/ //g" )
          else
            package_disabled_test=0
            package_enabled_test=0
          fi
          if [ "${package_disabled_test}" = "1" ]; then
            increment_insecure "Application \"${app_name}\" is disabled in \"${check_file}\""
            temp_file="${temp_dir}/${package_name}"
            backup_file      "${check_file}"
            lockdown_command="cat ${check_file} |sed 's/${package_name}=0//g' > ${temp_file} ; cat ${temp_file} > ${check_file} ; aa-enforce /etc/${package_name}.d/*"
            lockdown_message="Disabled Application/Package \"${app_name}\" in \"${check_file}\" to removed"
            if [ "${ansible_mode}" = 1 ]; then
              ansible_counter=$((ansible_counter+1))
              ansible_value="apparmor_check_${ansible_counter}"
              echo ""
              echo "- name: Checking ${string}"
              echo "  command: sh -c \"${disabled_get_command}\""
              echo "  register: ${ansible_value}"
              echo "  failed_when: ${ansible_value} != 0"
              echo "  changed_when: false"
              echo "  ignore_errors: true"
              echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
              echo ""
              echo "- name: Fixing ${string}"
              echo "  command: sh -c \"${lockdown_command}\""
              echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
              echo ""
            fi
          fi
          if [ "${package_enabled_test}" = "1" ]; then
            increment_secure "Application \"${app_name}\" is enabled in \"${check_file}\""
          else
            increment_insecure "Application \"${app_name}\" is not enabled in \"${check_file}\""
            temp_file="${temp_dir}/${package_name}"
            backup_file "${check_file}"
            if [ "${check_file}" = "/etc/default/grub" ]; then
              line_check=$( grep -c "^GRUB_CMDLINE_LINUX" "${check_file}" )
              if [ -n "${line_check}" ]; then
                existing_value=$( grep "^GRUB_CMDLINE_LINUX" < "${check_file}" |cut -f2 -d= |sed "s/\"//g" )
                new_value="GRUB_CMDLINE_LINUX=\"apparmor=1 security=apparmor ${existing_value}\""
                lockdown_command="cat ${check_file} |sed 's/^GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"${new_value}\"/g' > ${temp_file} ; cat ${temp_file} > ${check_file}"
                lockdown_message="Disabled Application/Package \"${app_name}\" removed"
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
              else
                lockdown_command="echo 'GRUB_CMDLINE_LINUX=\"apparmor=1 security=apparmor\"' >> ${check_file}"
                lockdown_message="Enabled ${app_name}"
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
              fi
            else
              if [ "${check_file}" = "/boot/grub/grub.cfg" ]; then
                lockdown_command="cat ${check_file} |sed 's/^\s*linux.*/& apparmor=1 security=apparmor/g' > ${temp_file} ; cat ${temp_file} > ${check_file} ; aa-enforce /etc/${package_name}.d/*"
                lockdown_message="Application/Package \"${app_name}\" in \"${check_file}\" to enabled"
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
              else
                lockdown_command="cat ${check_file} |sed 's/^\s*kernel.*/& apparmor=1 security=apparmor/g' > ${temp_file} ; cat ${temp_file} > ${check_file} ; enforce /etc/${package_name}.d/*"
                lockdown_message="Application/Package \"${app_name}\" in \"${check_file}\" to enabled"
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
              fi
            fi
          fi
        fi
      fi
    done 
  fi
}
