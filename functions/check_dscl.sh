#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# check_dscl
#
# Function to check dscl output under OS X
#.

check_dscl () {
  if [ "$os_name" = "Darwin" ]; then
    file="$1"
    param="$2"
    value="$3"
    dir="/var/db/dslocal/nodes/Default"
    if [ "$audit_mode" != 2 ]; then
      string="Parameter \"$param\" is set to \"$value\" in \"$file\""
      verbose_message "$string" "check"
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  command: sh -c \"sudo dscl . -read $file $param 2> /dev/null\""
        echo "  register: dscl_check"
        echo "  failed_when: dscl_check == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '$os_name'"
        echo ""
        echo "- name: Fixing $string"
        echo "  command: sh -c \"sudo dscl . -create $file $param '$value'\""
        echo "  when: dscl_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
        echo ""
      fi
      d_check=$( sudo dscl . -read "$file" "$param" 2> /dev/null | wc -l | sed "s/ //g" )
      if [ "$d_check" = "0" ]; then
        check="not-found"
      else
        check=$( sudo dscl . -read "$file" "$param" 2> /dev/null )
      fi
      if [ "$check" != "$value" ]; then
        increment_insecure "Parameter \"$param\" not set to \"$value\" in \"$file\""
        verbose_message    "sudo dscl . -create $file $param \"$value\"" "fix"
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file "$dir$file"
          verbose_message   "Parameter \"$param\" to \"$value\" in $file" "set"
          sudo dscl . -create "$file" "$param" "$value"
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "Parameter \"$param\" is set to \"$value\" in \"$file\""
        fi
      fi
    else
      funct_restore_file "$dir$file" "$restore_dir"
    fi
  fi
}
