#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# restore_file
#
# Restore file
#
# This routine restores a file from the backup directory to its original
# As par of the restore it also restores the original permissions
#
# check_file      = The name of the original file
# restore_dir     = The directory to restore from
#.

restore_file () {
  check_file="$1"
  check_dir="$2"
  if [ "${audit_mode}" = 2 ]; then
    if [ ! "${check_dir}" ]; then
      restore_file="${restore_dir}${check_file}"
    else
      restore_file="${check_dir}${check_file}"
    fi
    if [ -f "${restore_file}" ]; then
      sum_check_file=$( cksum "${check_file}" | awk '{print $1}' )
      sum_restore_file=$( cksum "${restore_file}" | awk '{print $1}' )
      if [ "$sum_check_file" != "$sum_restore_file" ]; then
        verbose_message "File \"${restore_file}\" to \"${check_file}\"" "restore"
        cp -p "${restore_file}" "${check_file}"
        if [ "${os_name}" = "SunOS" ]; then
          if [ "${os_version}" != "11" ]; then
            pkgchk -f -n -p "${check_file}" 2> /dev/null
          else
            pkg_info=$( pkg search "${check_file}" | grep pkg | awk '{print $4}' )
            pkg fix "${pkg_info}"
          fi
        fi
        if [ "${check_file}" = "/etc/system" ]; then
          reboot=1
          verbose_message "Reboot required" "notice"
        fi
        check_base=$( basename "${check_file}" )
        if [ "${check_base}" = "sshd_config" ]; then
          verbose_message "Notice:    Service restart required for SSH"
        fi
        if [ "${ansible}" = 1 ]; then
          echo ""
          echo "- name: Restart ssh service"
          echo "  service:"
          echo "    name:  ssh"
          echo "    state: restarted"
          echo ""
        fi
      fi
    fi
  fi
}
