#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# funct_check_pkg
#
# Check is a package is installed
#
# Install package if it's not installed and in the pkg dir under the base dir
# Needs some more work
#.

funct_check_pkg () {
  print_function "funct_check_pkg"
  if [ "${os_name}" = "SunOS" ]; then
    package_name="$1"
    package_check=$( pkginfo "$1" )
    log_file="${work_dir}/pkg.log"
    if [ "${audit_mode}" = 2 ]; then
      restore_file="${restore_dir}/pkg.log"
      if [ -f "${restore_file}" ]; then
        restore_check=$( grep "^${package_name}$" < "${restore_file}" | head -1 )
        if [ "$restore_check" = "${package_name}" ]; then
          if [ "${os_version}" = "11" ]; then
            execute_restore "pkg uninstall ${package_name}" "Package \"${package_name}\"" "sudo"
          else
            execute_restore "pkgrm ${package_name}" "Package \"${package_name}\"" "sudo"
          fi
        fi
      fi
    else
      string="Package \"${package_name}\" is installed"
      verbose_message "${string}" "check"
      if [ "${ansible_mode}" = 1 ]; then
        echo ""
        echo "- name: Checking ${string}"
        echo "  package:"
        echo "    name: ${package_name}"
        echo "    state: present"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
      package_test=$( echo "${package_check}" | grep "ERROR" )
      if [ -z "${package_test}" ]; then
        increment_secure "Package \"${package_name}\" is already installed"
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "Package \"${package_name}\" is not installed"
          pkg_dir="${base_dir}/pkg/${package_name}"
          if [ -d "$pkg_dir" ]; then
            verbose_message "Package \"${package_name}\"" "install"
            if [ "${os_version}" = "11" ]; then
              pkgadd "${package_name}"
            else
              pkgadd -d "${base_dir}/pkg" "${package_name}"
              package_check=$( pkginfo "$1" )
            fi
            package_test=$( echo "${package_check}" | grep "ERROR" )
            if [ -z "${package_check}" ]; then
              verbose_message "${package_name}" >> "${log_file}" "fix"
            fi
          fi
        fi
      fi
    fi
  fi
}
