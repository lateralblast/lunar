#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# check_sysadminctl
#
# Function to check sysadminctl output under OS X
#.

check_sysadminctl () {
  if [ "$os_name" = "Darwin" ]; then
    param="$1"
    value="$2"
    if [ "$value" = "off" ]; then
      search_value="disabled"
    fi
    if [ "$value" = "on" ]; then
      search_value="enabled"
    fi
    if [ "$audit_mode" != 2 ]; then
      string="Parameter \"$param\" is set to \"$value\""
      verbose_message "$string" "check"
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  command: sh -c \"sudo sysadminctl -$param status > /dev/null 2>&1 |grep $search_value\""
        echo "  register: sysadminctl_check"
        echo "  failed_when: \"$search_value\" not in sysadminctl_check"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '$os_name'"
        echo ""
        echo "- name: Fixing $string"
        echo "  command: sh -c \"sudo sysadminctl -$param $value\""
        echo "  when: sysadminctl_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
        echo ""
      fi
      check=$( eval "sudo sysadminctl -$param status > /dev/null 2>&1 | grep $search_value | wc -l | sed 's/ //g'" )
      if [ "$check" != "1" ]; then
        increment_insecure "Parameter \"$param\" not set to \"$value\""
        verbose_message    "sudo sysadminctl -$param $value" "fix"
        if [ "$audit_mode" = 0 ]; then
          backup_file    "$dir$file"
          verbose_message "Parameter \"$param\" to \"$value\"" "set"
          verbose_message "sudo sysadminctl -$param $value"
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "Parameter \"$param\" is set to \"$value\""
        fi
      fi
    else
      funct_restore_file "$dir$file" "$restore_dir"
    fi
  fi
}
