#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# check_auditctl
#
# Check whether a executable, file or directory is being audited
#.

check_auditctl () {
  check_file="$1"
  audit_tag="$2"
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      secure_string="Auditing is enabled on file \"$check_file\""
      insecure_string="Auditing is not enabled on file \"$check_file\""
      verbose_message "$secure_string" "check"
      if [ -e "$check_file" ]; then
        check=$( auditctl -l | grep "$check_file" )
        if [ ! "$check" ]; then
          if [ "$ansible" = 1 ]; then
            echo ""
            echo "- name: Checking $secure_string"
            echo "  command: sh -c \"auditctl -l | grep $check_file\""
            echo "  register: auditctl_file_check_$audit_tag"
            echo "  failed_when: auditctl_file_check_$audit_tag == 1"
            echo "  changed_when: false"
            echo "  ignore_errors: true"
            echo "  when: ansible_facts['ansible_system'] == '$os_name'"
            echo ""
            echo "- name: Enable Auditing for $file"
            echo "  command: sh -c \"auditctl -w $file -p wa -k $audit_tag\""
            echo "  when: audit_file_check_$audit_tag.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
            echo ""
          fi
          increment_insecure "$insecure_string"
        else
          increment_secure   "$secure_string"
        fi
      fi
    fi
  fi
}
