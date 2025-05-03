#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sendmail_greeting
#
# Check sendmail greeting
#.

audit_sendmail_greeting () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    check_file="/etc/mail/sendmail.cf"
    if [ -f "${check_file}" ]; then
      verbose_message "Sendmail Greeting" "check"
      search_string="v/"
      restore=0
      if [ "${audit_mode}" != 2 ]; then
        check_value=$( grep -v '^#' "${check_file}" | grep 'O SmtpGreetingMessage' | awk '{print $4}' | grep 'v/' )
        if [ "${check_value}" = "${search_string}" ]; then
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "Found version information in sendmail greeting"
            verbose_message    "cp ${check_file} ${temp_file}" fix
            verbose_message    "awk '/O SmtpGreetingMessage=/ { print \"O SmtpGreetingMessage=Mail Server Ready; \$b\"; next} { print }' < ${temp_file} > ${check_file}" "fix"
            verbose_message    "rm ${temp_file}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file      "${check_file}"
            verbose_message  "Sendmail greeting to have no version information" "set"
            cp "${check_file}" "${temp_file}"
            awk '/O SmtpGreetingMessage=/ { print "O SmtpGreetingMessage=Mail Server Ready; $b"; next} { print }' < "${temp_file}" > "${check_file}"
            if [ -f "${temp_file}" ]; then
              rm "${temp_file}"
            fi
          fi
        else
          if [ "${audit_mode}" = "1" ]; then
            increment_secure "No version information in sendmail greeting"
          fi
        fi
      else
        restore_file "${check_file}" "${restore_dir}"
      fi
      disable_value ${check_file} "O HelpFile" hash
      if [ "${audit_mode}" != 2 ]; then
        check_value=$( grep -v '^#' ${check_file} | grep "${search_string}" )
        if [ "${check_value}" = "${search_string}" ]; then
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "Found help information in sendmail greeting"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file      "${check_file}"
            verbose_message  "Sendmail to have no help information" "set"
            cp  "${check_file}" "${temp_file}"
            sed 's/^O HelpFile=/#O HelpFile=/' < "${temp_file}" > "${check_file}"
            if [ -f "${temp_file}" ]; then
              rm "${temp_file}"
            fi
          fi
        else
          if [ "${audit_mode}" = "1" ]; then
            increment_secure "No help information in sendmail greeting"
          fi
        fi
      else
        restore_file   "${check_file}" "${restore_dir}"
      fi
      check_file_perms "${check_file}" "0444" "root" "root"
    fi
  fi
}
