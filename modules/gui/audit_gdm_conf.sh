#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_gdm_conf
#
# Gnome Display Manager should not be used on a server, but if it is it
# should be locked down to disable root access.
#
# Refer to Section(s) 1.8.10    Page(s) 193-4       CIS Ubuntu 22.04 Benchmaek v1.0.0
# Refer to Section(s) 1.7.1,10  Page(s) 197-8,223-5 CIS Ubuntu 24.04 Benchmaek v1.0.0
#.

audit_gdm_conf () {
  print_function "audit_gdm_conf"
  string="GDM Configuration"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    check_file="/etc/X11/gdm/gdm.conf"
    if [ -e "${check_file}" ]; then
      check_linux_package "uninstall" "gdm3"
      verbose_message     "${string}" "check"
      check_file_value    "is" "${check_file}"    "AllowRoot"       "eq"  "false" "hash"
      check_file_value    "is" "${check_file}"    "AllowRemoteRoot" "eq"  "false" "hash"
      check_file_value    "is" "${check_file}"    "Use24Clock"      "eq"  "true"  "hash"
      check_file_perms    "${check_file}" "0644"  "root" "root"
    fi
    check_file="/etc/gdm3/greeter.dconf-defaults"
    if [ -e "${check_file}" ]; then
      verbose_message  "GDM3 Greeter User List Configuration" "check"
      check_file_value "is" "${check_file}" "disable-user-list"     "eq"  "true"  "hash"
    fi
    for check_file in /etc/gdm/custom.conf /etc/gdm3/custom.conf /etc/gdm/daemon.conf /etc/gdm3/daemon.conf; do
      if [ -e "${check_file}" ]; then
        verbose_message  "GDM3 XDMCP Configuration" "check"
        check_file_value_with_position "is" "${check_file}" "Enable" "eq" "false" "hash" "after" "xdmcp"
      fi
    done
  else
    na_message "${string}"
  fi
}
