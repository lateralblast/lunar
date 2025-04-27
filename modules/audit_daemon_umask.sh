#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_daemon_umask
#
# Check daemon umask
#
# Refer to Section(s) 3.1 Page(s) 58-9 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.2 Page(s) 72   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.1 Page(s) 61-2 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.3 Page(s) 9-10 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1 Page(s) 75-6 CIS Solaris 10 Benchmark v5.1.0
#.

audit_daemon_umask () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    verbose_message "Daemon Umask" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "11" ]; then
        umask_check=$( svcprop -p umask/umask svc:/system/environment:init )
        umask_value="022"
        log_file="umask.log"
        if [ "${umask_check}" != "${umask_value}" ]; then
          log_file="${work_dir}/${log_file}"
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Default service file creation mask not set to ${umask_value}"
            verbose_message    "svccfg -s svc:/system/environment:init setprop umask/umask = astring:  \"${umask_value}\"" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            verbose_message "Setting:   Default service file creation mask to ${umask_value}"
            if [ ! -f "${log_file}" ]; then
              echo "${umask_check}" >> "${log_file}"
            fi
            svccfg -s svc:/system/environment:init setprop umask/umask = astring:  "${umask_value}"
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "Default service file creation mask set to ${umask_value}"
          fi
          if [ "${audit_mode}" = 2 ]; then
            restore_file="${restore_dir}/${log_file}"
            if [ -f "${restore_file}" ]; then
              restore_value=$( cat "${restore_file}" )
              if [ "${restore_value}" != "${umask_check}" ]; then
                verbose_message "Restoring:  Default service file creation mask to ${restore_value}"
                svccfg -s svc:/system/environment:init setprop umask/umask = astring:  "${restore_value}"
              fi
            fi
          fi
        fi
      else
        if [ "${os_version}" = "7" ] || [ "${os_version}" = "6" ]; then
          check_file="/etc/init.d/umask.sh"
          check_file_value "is" "${check_file}" "umask" "space" "022" "hash"
          if [ "${audit_mode}" = "0" ]; then
            if [ -f "${check_file}" ]; then
              check_file_perms "${check_file}" "0744" "root" "sys"
              for dir_name in /etc/rc?.d; do
                link_file="${dir_name}/S00umask"
                if [ ! -f "$link_file" ]; then
                  ln -s "${check_file}" "$link_file"
                fi
              done
            fi
          fi
        else
          check_file="/etc/default/init"
          check_file_value "is" "${check_file}" "CMASK" "eq" "022" "hash"
        fi
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_file="/etc/sysconfig/init"
      check_file_value "is" "${check_file}" "umask" "space" "027" "hash"
      if [ "${audit_mode}" = "0" ]; then
        if [ -f "${check_file}" ]; then
          check_file_perms "${check_file}" "0755" "root" "root"
        fi
      fi
    fi
    # Check relevant /etc/* directoris for files with a potential umasks
    for dir_name in /etc /etc/rc0.d /etc/rc1.d /etc/rc2.d /etc/rc4.d /etc/rc5.d /etc/rcS.d /usr/local/etc; do
      if [ -e "${dir_name}" ]; then
        file_list=$( find /etc/ -maxdepth 1 -type f )
        for check_file in ${file_list}; do
          umask_test=$( grep -c "umask" "${check_file}" | sed "s/ //g" )
          if [ ! "$umask_test" = "0" ]; then
            check_file_value "is" "${check_file}" "umask" "space" "077" "hash"
          fi
        done
      fi
    done 
  fi
}
