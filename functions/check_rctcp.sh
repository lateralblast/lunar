#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_rctcp
#
# Function to check rctcp under AIX
#.

check_rctcp() {
  print_function "check_rctcp"
  if [ "${os_name}" = "AIX" ]; then
    service_name="$1"
    correct_value="$2"
    if [ "${correct_value}" = "off" ]; then
      status_value="disabled"
    else
      status_value="enabled"
    fi
    log_file="${service_name}.log"
    actual_value=$( lssrc -a | grep "${service_name} " | awk '{print $4}' )
    if [ "${actual_value}" = "active" ]; then
      actual_value="off"
    else
      actual_value="on"
    fi
    if [ "${audit_mode}" != 2 ]; then
      string="Service \"${service_name}\" is \"${correct_value}\""
      verbose_message "${string}" "check"
      if [ "${ansible_mode}" = 1 ]; then
        echo ""
        echo "- name: Checking ${string}"
        echo "  service:"
        echo "    name: ${service_name}"
        echo "    enabled: ${status_value}"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
      if [ "${actual_value}" != "${correct_value}" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "Service \"${service_name}\" is not \"${correct_value}\""
          if [ "${correct_value}" = "off" ]; then
            verbose_message "chrctcp -d ${service_name}" "fix"
            verbose_message "stopsrc -s ${service_name}" "fix"
            verbose_message "sed \"/${service_name} /s/^/#/g\" < /etc/rc.tcpip > ${temp_file}" "fix"
            verbose_message "cat ${temp_file} > /etc/rc.tcpip" "fix"
            verbose_message "rm ${temp_file}" "fix"
          else
            verbose_message "chrctcp -a ${service_name}" "fix"
            verbose_message "startsrc -s ${service_name}" "fix"
            verbose_message "sed \"/${service_name} /s/^#.//g\" < /etc/rc.tcpip > ${temp_file}" "fix"
            verbose_message "cat ${temp_file} > /etc/rc.tcpip" "fix"
            verbose_message "rm ${temp_file}" "fix"
          fi
        fi
        if [ "${audit_mode}" = 0 ]; then
          log_file="${work_dir}/${log_file}"
          verbose_message "Service \"${service_name}\" to \"${correct_value}\"" "set"
          echo "${actual_value}" > "${log_file}"
          if [ "${correct_value}" = "off" ]; then
            chrctcp -d "${service_name}"
            stopsrc -s "${service_name}"
            sed "/${service_name} /s/^/#/g" < /etc/rc.tcpip > "${temp_file}"
            cat "${temp_file}" > /etc/rc.tcpip
            rm  "${temp_file}"
          else
            chrctcp -a "${service_name}"
            startsrc -s "${service_name}"
            sed "/${service_name} /s/^#.//g" < /etc/rc.tcpip > "${temp_file}"
            cat "${temp_file}" > /etc/rc.tcpip
            rm  "${temp_file}"
          fi
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Service \"${service_name}\" is \"${correct_value}\""
        fi
      fi
    else
      log_file="${restore_dir}/${log_file}"
      if [ -f "${log_file}" ]; then
        previous_value=$( cat "${log_file}" )
        if [ "${previous_value}" != "${actual_value}" ]; then
          verbose_message "Service \"${service_name}\" to \"${previous_value}\"" "restore"
          if [ "${previous_value}" = "off" ]; then
            chrctcp -d "${service_name}"
            stopsrc -s "${service_name}"
            sed "/${service_name} /s/^/#/g" < /etc/rc.tcpip > "${temp_file}"
            cat "${temp_file}" > /etc/rc.tcpip
            rm  "${temp_file}"
          else
            chrctcp -a "${service_name}"
            startsrc -s "${service_name}"
            sed "/${service_name} /s/^#.//g" < /etc/rc.tcpip > "${temp_file}"
            cat "${temp_file}" > /etc/rc.tcpip
            rm  "${temp_file}"
          fi
        fi
      fi
    fi
  fi
}
