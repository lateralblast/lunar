#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# funct_check_pkg
#
# Check is a package is installed
#
# Install package if it's not installed and in the pkg dir under the base dir
# Needs some more work
#.

funct_check_pkg () {
  if [ "$os_name" = "SunOS" ]; then
    pkg_name="$1"
    pkg_check=$( pkginfo "$1" )
    log_file="$work_dir/pkg.log"
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/pkg.log"
      if [ -f "$restore_file" ]; then
        restore_check=$( grep "^$pkg_name$" < "$restore_file" | head -1 )
        if [ "$restore_check" = "$pkg_name" ]; then
          if [ "$os_version" = "11" ]; then
            restore_command "pkg uninstall $pkg_name" "Package \"$pkg_name\""
          else
            restore_command "pkgrm $pkg_name" "Package \"$pkg_name\""
          fi
        fi
      fi
    else
      string="Package \"$pkg_name\" is installed"
      verbose_message "$string" "check"
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  package:"
        echo "    name: $pkg_name"
        echo "    state: present"
        echo "  when: ansible_facts['ansible_system'] == '$os_name'"
        echo ""
      fi
      p_test=$( echo "$pkg_check" |grep "ERROR" )
      if [ -z "$pkg_test" ]; then
        increment_secure "Package \"$pkg_name\" is already installed"
      else
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Package \"$pkg_name\" is not installed"
          pkg_dir="$base_dir/pkg/$pkg_name"
          if [ -d "$pkg_dir" ]; then
            verbose_message "Package \"$pkg_name\"" "install"
            if [ "$os_version" = "11" ]; then
              pkgadd "$pkg_name"
            else
              pkgadd -d "$base_dir/pkg" "$pkg_name"
              pkg_check=$( pkginfo "$1" )
            fi
            p_test=$( echo "$pkg_check" |grep "ERROR" )
            if [ -z "$pkg_check" ]; then
              verbose_message "$pkg_name" >> "$log_file" "fix"
            fi
          fi
        fi
      fi
    fi
  fi
}
