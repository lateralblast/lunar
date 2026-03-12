#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_linux_package
#
# Check package
# Takes the following variables:
# package_mode:   Mode, eg check install uninstall restore
# package_check:  Package to check for
#.

check_linux_package_with_group () {
  if [ "${os_name}" = "Linux" ]; then
    package_mode="${1}"
    package_check="${2}"
    group_check="${3}"
    print_function "check_linux_package_with_group"
    package_type="Package"
    if [ "${package_mode}" = "install" ]; then
      package_status="installed"
      package_state="present"
    else
      package_status="uninstalled"
      package_state="absent"
    fi
    log_file="package_log"
    if [ "${audit_mode}" != "2" ]; then
      string="${package_type} \"${package_check}\" is \"${package_status}\""
      check_message "${string}"
      if [ "${ansible_mode}" = 1 ]; then
        echo ""
        echo "- name: ${string}"
        echo "  package:"
        echo "    name: ${package_check}"
        echo "    state: $package_state"
        echo ""
      fi
      if [ "${linux_dist}" = "debian" ]; then
        package_name=$( dpkg -l "${package_check}" 2>&1 | grep "${package_check}" | awk '{print $2}' )
      else
        if [ "${linux_dist}" = "arch" ]; then
          package_name=$( pacman -Qi "${package_check}" 2>&1 | grep '^Name' | awk '{print $3}' )
        else
          if [ ! "${group_check}" = "" ]; then
            package_type="Group"
            package_name=$( yum grouplist 2>&1 | grep "${package_check}" | sed "s/^   //g" )
          else
            package_name=$( rpm -qi "${package_check}" | grep '^Name' | awk '{print $3}' )
          fi
        fi
      fi
      if [ "${package_mode}" = "install" ] && [ "${package_name}" = "${package_check}" ]; then
        inc_secure "${package_type} \"${package_check}\" is \"${package_status}\""
      else
        if [ "${package_mode}" = "uninstall" ] && [ "${package_name}" != "${package_check}" ] || [ "${package_name}" = "" ]; then
          inc_secure   "${package_type} \"${package_check}\" is \"${package_status}\""
        else
          inc_insecure "${package_type} \"${package_check}\" is not \"${package_status}\""
        fi
      fi
      if [ "${package_mode}" = "install" ]; then
        if [ "${linux_dist}" = "redhat" ]; then
          if [ "${group_check}" ]; then
            package_command="yum -y groupinstall ${package_check}"
          else
            package_command="yum -y install ${package_check}"
          fi
        fi
        if [ "${linux_dist}" = "suse" ]; then
          package_command="zypper install ${package_check}"
        fi
        if [ "${linux_dist}" = "debian" ]; then
          package_command="apt-get install ${package_check}"
        fi
        if [ "${linux_dist}" = "arch" ]; then
          package_command="pacman -S ${package_check}"
        fi
        if [ "${package_check}" = "aide" ]; then
          if [ -f "/usr/sbin/aide" ]; then
            if [ ! -f "/var/lib/aide/aide.db.gz" ]; then
              /usr/sbin/aide --init -B "database_out=file:/var/lib/aide/aide.db.gz"
            fi
          fi
        fi
      fi
      if [ "${package_mode}" = "uninstall" ]; then
        if [ "${linux_dist}" = "redhat" ]; then
          if [ "${group_check}" ]; then
            package_command="yum -y groupremove ${package_check}"
          else
            package_command="rpm -e ${package_check}"
          fi
        fi
        if [ "${linux_dist}" = "suse" ]; then
          package_command="zypper remove ${package_check}"
        fi
        if [ "${linux_dist}" = "debian" ]; then
          package_command="apt-get purge ${package_check}"
        fi
        if [ "${linux_dist}" = "arch" ]; then
          package_command="pacman -R ${package_check}"
        fi
      fi
      lock_message="${package_type} \"${package_check}\" to \"${package_status}\""
      if [ "${audit_mode}" = "0" ] && [ "${package_mode}" != "check" ]; then
        if [ "$package_uninstall" = "yes" ]; then
          update_log   "${log_file}" "${package_check},${package_mode}"
          lock_command="${package_command}"
          run_lockdown "${lock_command}" "${lock_message}"
        else
          inc_insecure "Not uninstalling package as package uninstall has been set to no"
          fix_message  "${package_command}"
        fi
      else
        fix_message    "${package_command}"
      fi
    else
      restore_file="${restore_dir}/${log_file}"
      if [ -f "${restore_file}" ]; then
        restore_check=$( grep "${package_check}" "${restore_file}" | awk '{print $2}' )
        if [ "$restore_check" = "${package_check}" ]; then
          package_action=$( grep "${package_check}" "${restore_file}" | awk '{print $1}' )
          restore_message="Package \"${package_check}\" to\" ${package_action}\""
          if [ "${package_action}" = "install" ]; then
            if [ "${linux_dist}" = "redhat" ]; then
              if [ "${group_check}" ]; then
                restore_command="yum groupremove ${package_check}"
              else
                restore_command="rpm -e ${package_check}"
              fi
            fi
            if [ "${linux_dist}" = "debian" ]; then
              restore_command="apt-get purge ${package_check}"
            fi
            if [ "${linux_dist}" = "suse" ]; then
              restore_command="zypper remove ${package_check}"
            fi
            if [ "${linux_dist}" = "arch" ]; then
              restore_command="pacman -R ${package_check}"
            fi
          else
            if [ "${linux_dist}" = "redhat" ]; then
              if [ "${group_check}" ]; then
                restore_command="yum groupinstall ${package_check}"
              else
                restore_command="yum -y install ${package_check}"
              fi
            fi
            if [ "${linux_dist}" = "debian" ]; then
              restore_command="apt-get install ${package_check}"
            fi
            if [ "${linux_dist}" = "suse" ]; then
              restore_command="zypper install ${package_check}"
            fi
            if [ "${linux_dist}" = "arch" ]; then
              restore_command="pacman -S ${package_check}"
            fi
          fi
          execute_restore "${restore_command}" "${restore_message}" "sudo"
        fi
      fi
    fi
  fi
}

check_linux_package () {
  check_linux_package_with_group "${1}" "${2}" ""
}
