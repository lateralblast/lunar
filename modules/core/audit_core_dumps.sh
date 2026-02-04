#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2043

# audit_core_dumps
#
# Check core dumps
#
# Refer to Section(s) 1.6.1 Page(s) 44-5  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.6.1 Page(s) 50-1  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.5.1 Page(s) 47    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.4.1 Page(s) 57    CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 4.1   Page(s) 35-6  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.5.1 Page(s) 56-7  CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.5.3 Page(s) 175-8 CIS Ubuntu 24.04 Benchmark v1.0.0
# Refer to Section(s) 4.1   Page(s) 16    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 3.1   Page(s) 25-6  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 3.2   Page(s) 61-2  CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 1.5.1 Page(s) 53    CIS Amazon Linux Benchmark v2.0.0
#.

audit_core_dumps () {
  print_function "audit_core_dumps"
  string="Core Dumps"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" != "6" ]; then
        cores_dir="/var/cores"
        check_file="/etc/coreadm.conf"
        command="coreadm | head -1 | awk '{print \$5}' | grep \"/var/cores\""
        command_message "${command}"
        cores_check=$( eval "${command}" )
        if [ -z "${cores_check}" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Cores are not restricted to a private directory"
          else
            if [ "${audit_mode}" = 0 ]; then
              verbose_message "Making sure restricted to a private directory" "set"
              if [ -f "${check_file}" ]; then
                verbose_message "File \"${check_file}\" to \"${work_dir}${check_file}\"" "save"
                find "${check_file}" | cpio -pdm "${work_dir}" 2> /dev/null
              else
                touch "${check_file}"
                find "${check_file}" | cpio -pdm "${work_dir}" 2> /dev/null
                if [ -f "${check_file}" ]; then
                  rm "${check_file}"
                fi
                log_file="${work_dir}/${check_file}"
                coreadm | sed -e 's/^ *//g' | sed 's/ /_/g' | sed 's/:_/:/g' | awk -F: '{ print $1" "$2 }' | while read -r option value; do
                  if [ "$option" = "global_core_file_pattern" ]; then
                    echo "COREADM_GLOB_PATTERN=${value}" > "${log_file}"
                  fi
                  if [ "$option" = "global_core_file_content" ]; then
                    echo "COREADM_GLOB_CONTENT=${value}" >> "${log_file}"
                  fi
                  if [ "$option" = "init_core_file_pattern" ]; then
                    echo "COREADM_INIT_PATTERN=${value}" >> "${log_file}"
                  fi
                  if [ "$option" = "init_core_file_content" ]; then
                    echo "COREADM_INIT_CONTENT=${value}" >> "${log_file}"
                  fi
                  if [ "$option" = "global_core_dumps" ]; then
                    if [ "${value}" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_ENABLED=${value}" >> "${log_file}"
                  fi
                  if [ "$option" = "per-process_core_dumps" ]; then
                    if [ "${value}" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_PROC_ENABLED=${value}" >> "${log_file}"
                  fi
                  if [ "$option" = "global_setid_core_dumps" ]; then
                    if [ "${value}" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_SETID_ENABLED=${value}" >> "${log_file}"
                  fi
                  if [ "$option" = "per-process_setid_core_dumps" ]; then
                    if [ "${value}" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_PROC_SETID_ENABLED=${value}" >> "${log_file}"
                  fi
                  if [ "$option" = "global_core_dump_logging" ]; then
                    if [ "${value}" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_LOG_ENABLED=${value}" >> "${log_file}"
                  fi
                done
              fi
              coreadm -g /var/cores/core_%n_%f_%u_%g_%t_%p -e log -e global -e global-setid -d process -d proc-setid
            fi
            if [ ! -d "${cores_dir}" ]; then
              mkdir "${cores_dir}"
              chmod 700 "${cores_dir}"
              chown root:root "${cores_dir}"
            fi
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "Cores are restricted to a private directory"
          fi
        fi
        if [ "${audit_mode}" = 2 ]; then
          restore_file="${restore_dir}${check_file}"
          restore_file "${check_file}" "${restore_dir}"
          if [ -f "${restore_file}" ]; then
            coreadm -u
          fi
        fi
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      verbose_message     "Core Dumps" "check"
      check_linux_service "kdump"      "off"
      check_append_file   "/etc/security/limits.conf" "* hard core 0"     "hash"
      check_file_value    "is" "/etc/sysctl.conf"     "fs.suid_dumpable"  "eq"  "0" "hash"
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file_value    "is" "/etc/sysctl.conf"     "kern.coredump"     "eq"  "0" "hash"
    fi
  else
    na_message "${string}"
  fi
}
