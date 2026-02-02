#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2046
# shellcheck disable=SC2154

# audit_logrotate
#
# Check logrotate
#
# Refer to Section(s) 4.3     Page(s) 97    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.3     Page(s) 120-1 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 4.3     Page(s) 208   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 8.4     Page(s) 113-4 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 4.3     Page(s) 191   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.1.3.8 Page(s) 787-8 CIS Ubuntu LTS 24.04 Benchmark v1.0.0
#.

audit_logrotate () {
  print_function "audit_logrotate"
  if [ "${os_name}" = "Linux" ]; then
    for check_file in /etc/logrotate.d/syslog /etc/logrotate.d/rsyslog; do
      if [ -f "${check_file}" ]; then
        verbose_message "Log Rotate Configuration" "check"
        if [ "${audit_mode}" != 2 ]; then
          if [ "${os_vendor}" = "SuSE" ]; then
            search_string="/var/log/warn /var/log/messages /var/log/allmessages /var/log/localmessages /var/log/firewall /var/log/acpid /var/log/NetworkManager /var/log/mail /var/log/mail.info /var/log/mail.warn /var/log/mail.err /var/log/news/news.crit /var/log/news/news.err /var/log/news/news.notice"
          else
            search_string="/var/log/messages /var/log/secure /var/log/maillog /var/log/spooler /var/log/boot.log /var/log/cron"
          fi
          command="grep \"${search_string}\" \"${check_file}\" | sed 's/ {//g'"
          command_message "${command}"
          check_value=$( eval "${command}" )
          if [ "${check_value}" != "${search_string}" ]; then
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "Log rotate is not configured for ${search_string}"
              verbose_message    "cat ${check_file} |sed 's,.*{,${search_string} {,' > ${temp_file}" "fix"
              verbose_message    "cat ${temp_file} > ${check_file}" "fix"
              verbose_message    "rm ${temp_file}" "fix"
            fi
            if [ "${audit_mode}" = 0 ]; then
              backup_file "${check_file}"
              echo  "Removing:  Configuring logrotate"
              command="sed \"s,.*{,${search_string} {,\" \"${check_file}\" > \"${temp_file}\""
              command_message "${command}"
              eval "${command}"
              command="cat \"${temp_file}\" > \"${check_file}\""
              command_message "${command}"
              eval "${command}"
              if [ -f "${temp_file}" ]; then
                rm "${temp_file}"
              fi
            fi
          else
            if [ "${audit_mode}" = 1 ]; then
              increment_secure "Log rotate is configured"
            fi
          fi
        else
          restore_file "${check_file}" "${restore_dir}"
        fi
      fi
    done
  fi
}
