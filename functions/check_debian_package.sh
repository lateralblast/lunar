#!/bin/sh

# -> Needs checking for install_check

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_debian_package
#
# Check if a deb is installed, if so install_check will be be set with name of dep,
# otherwise it will be empty
#.

check_debian_package () {
  package_name="$1"
  verbose_message "Debian package \"${package_name}\"" "check"
  install_check=$( dpkg -l "${package_name}" 2>&1 | grep "${package_name}" | awk '{print $2}' | grep "^${package_name}$" )
}
