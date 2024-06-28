#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_gdm_conf
#
# Gnome Display Manager should not be used on a server, but if it is it
# should be locked down to disable root access.
# Refer to Section(s) 1.8.10 Page(s) 193-4 CIS Ubuntu 22.04 Benchmaek v1.0.0
#.

audit_gdm_conf () {
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/X11/gdm/gdm.conf"
    if [ -e "$check_file" ]; then
      verbose_message  "GDM X11 Allow Configuration" "chek"
      check_file_value "is" "$check_file" "AllowRoot"       "eq" "false" "hash"
      check_file_value "is" "$check_file" "AllowRemoteRoot" "eq" "false" "hash"
      check_file_value "is" "$check_file" "Use24Clock"      "eq" "true"  "hash"
      check_file_perms "$check_file" "0644" "root" "root"
    fi
    check_file="/etc/gdm3/greeter.dconf-defaults"
    if [ -e "$check_file" ]; then
      verbose_message  "GDM3 Greeter User List Configuration" "check"
      check_file_value "is" "$check_file" "disable-user-list" "eq" "true" "hash"
    fi
    check_file="/etc/gdm3/custom.conf"
    if [ -e "$check_file" ]; then
      verbose_message  "GDM3 XDMCP Configuration" "check"
      check_file_value "is" "$check_file" "Enable" "eq" "false" "hash" "after" "xdmcp"
    fi
  fi
}
