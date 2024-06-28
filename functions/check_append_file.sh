#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# check_append_file
#
# Code to append a file with a line
#
# check_file      = The name of the original file
# parameter       = The parameter/line to add to a file
# comment_value   = The character used in the file to distinguish a line as a comment
#.

check_append_file () {
  check_file="$1"
  parameter="$2"
  comment_value="$3"
  if [ "$comment_value" = "star" ]; then
    comment_value="*"
  else
    comment_value="#"
  fi
  if [ "$audit_mode" = 2 ]; then
    restore_file="$restore_dir$check_file"
    restore_file "$check_file" "$restore_dir"
  else
    secure_string="Parameter \"$parameter\" is set in \"$check_file\""
    insecure_string="Parameter \"$parameter\" is not set in \"$check_file\""
    verbose_message "$secure_string" "check"
    if [ ! -f "$check_file" ]; then
      increment_insecure "Parameter \"$parameter\" does not exist in \"$check_file\""
      lockdown_command   "echo \"$parameter\" >> $check_file"
      if [ "$parameter" ]; then
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: Checking $secure_string"
          echo "  lineinfile:"
          echo "    path: $check_file"
          echo "    line: '$parameter'"
          echo "    create: yes"
          echo ""
        fi
      fi
    else
      if [ "$parameter" ]; then
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: Checking $secure_string"
          echo "  lineinfile:"
          echo "    path: $check_file"
          echo "    line: '$parameter'"
          echo ""
        fi
        check_value=$( grep -v "^$comment_value" "$check_file" | grep -- "$parameter" )
        if [ "$check_value" != "$parameter" ]; then
          increment_insecure "$insecure_string"
          backup_file        "$check_file"
          lockdown_command   "echo \"$parameter\" >> $check_file"
        else
          increment_secure   "$secure_string"
        fi
      fi
    fi
  fi
}
