#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# backup_file
#
# Backup file
#.

backup_file () {
  print_function "backup_file"
  check_file="${1}"
  if [ -f "${check_file}" ]; then
    if [ "${audit_mode}" = 0 ]; then
      backup_file="${work_dir}${check_file}"
      if [ ! -f "${backup_file}" ]; then
        verbose_message "File \"${check_file}\" to \"${backup_file}\"" "backup"
        command="find \"${check_file}\" | cpio -pdm \"${work_dir}\" 2> /dev/null"
        command_message "${command}"
        eval "${command}"
        if [ "${check_file}" = "/etc/system" ]; then
          reboot_required=1
        	verbose_message "Notice:    Reboot required"
        fi
        check_base=$( basename "${check_file}" )
        if [ "${check_base}" = "sshd_config" ]; then
          verbose_message "Notice:    Service restart required for SSH"
        fi
        if [ "${ansible_mode}" = 1 ]; then
          echo ""
          echo "- name: Restart ssh service"
          echo "  service:"
          echo "    name:  ssh"
          echo "    state: restarted"
          echo ""
        fi
      fi
    fi
  else
    verbose_message "File \"${check_file}\" does not exist" "warn"
  fi
}
