#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_touch_id
#
# Touch ID allows for an account-enrolled fingerprint to access a key that uses a
# previously provided password.
#
# Refer to Section(s) 2.11.2 Page(s) 237-40 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_touch_id () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      ansible_counter=$((ansible_counter+1))
      name="audit_touch_id_${ansible_counter}"
      string="Touch ID"
      verbose_message "${string}" "check"
      if [ "${audit_mode}" != 2 ]; then
        check_value=$( sudo bioutil -r -s | grep timeout | head -1 | cut -f2 -d: | sed "s/ //g" )
        if [ "${check_value}" = "${touchid_timeout}" ]; then
          increment_secure   "Touch ID Timeout for system is set to \"${touchid_timeout}\""
        else
          increment_insecure "Touch ID Timeout for system is not set to \"${touchid_timeout}\""
        fi
        if [ "${ansible}" = 1 ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"sudo bioutil -r -s | grep timeout | head -1 | cut -f2 -d: | grep -c ${touchid_timeout} | sed 's/ //g'\""
          echo "  register: ${name}"
          echo "  failed_when: ${name} != 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sh -c \"/usr/bin/sudo usr/bin/bioutil -w -s -o ${touchid_timeout}\""
          echo "  when: ${name}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        else
          lockdown_command "/usr/bin/sudo usr/bin/bioutil -w -s -o ${touchid_timeout}" " ${string}"
        fi
        for item in unlock ApplePay ; do
          string="Touch ID ${item}"
          verbose_message "${string}" "check"
          user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ )
          for user_name in ${user_list}; do
            check_value=$( sudo -u "${user_name}" bioutil -r -s | grep "${item}" | head -1 | cut -f2 -d: | sed "s/ //g" > /dev/null 2>&1 )
            if [ "${check_value}" = "${touchid_timeout}" ]; then
              increment_secure   "Touch ID Timeout for user \"${user_name}\" is set to \"${touchid_timeout}\""
            else
              increment_insecure "Touch ID Timeout for for user \"${user_name}\" is not set to \"${touchid_timeout}\""
            fi
            if [ "${ansible}" = 1 ]; then
              echo ""
              echo "- name: Checking ${string} for ${user_name}"
              echo "  command: sh -c \"sudo -u ${user_name} bioutil -r -s | grep ${item} | head -1 | cut -f2 -d: | sed 's/ //g'\""
              echo "  register: audit_touch_id_check"
              echo "  failed_when: audit_touch_id_check != 1"
              echo "  changed_when: false"
              echo "  ignore_errors: true"
              echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
              echo ""
              echo "- name: Fixing ${string}"
              if [ "${item}" = "unlock" ]; then
                echo "  command: sh -c \"/usr/bin/sudo usr/bin/bioutil -w -u 1\""
              else
                echo "  command: sh -c \"/usr/bin/sudo usr/bin/bioutil -w -a 1\""
              fi
              echo "  when: audit_touch_id_check.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
              echo ""
            else
              if [ "${item}" = "unlock" ]; then
                lockdown_command "/usr/bin/sudo usr/bin/bioutil -w -u 1" " ${string}"
              else
                lockdown_command "/usr/bin/sudo usr/bin/bioutil -w -s 1" " ${string}"
              fi
            fi
          done
        done
      fi
    fi
  fi
}
