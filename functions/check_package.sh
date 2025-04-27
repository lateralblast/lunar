#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_package
#
# Check Package
#.

check_package () {
  package_name="$1"
  if [ "${os_name}" = "Linux" ]; then
  	check_linux_package "${package_name}"
  fi
  if [ "${os_name}" = "SunOS" ]; then
  	check_solaris_package "${package_name}"
  fi
}