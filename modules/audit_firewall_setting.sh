#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_firewall_setting
#
# Apple's firewall will protect your computer from certain incoming attacks.
# Apple offers three firewall options: Allow all, Allow only essential, and
# Allow access for specific incoming connections. Unless you have a specific
# need to allow incoming connection (for services such as SSH, file sharing,
# or web services), set the firewall to "Allow only essential services,"
# otherwise use the "allow access for specific incoming connections" option.
#
# 0 = off
# 1 = on for specific services
# 2 = on for essential services
#
# Refer to Section(s) 2.6.4       Page(s)            CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section(s) 2.6.3       Page(s) 56-7       CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.2.1-2,3.6 Page(s) 60-9,283-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_firewall_setting () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message    "Firewall Settings" "check"
    check_osx_defaults "/Library/Preferences/com.apple.alf globalstate" "1" "int"
    if [ "$audit_mode" != 2 ]; then
     	check=$( sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode | egrep "enabled|on" )
      if [ "$check" ]; then
        increment_secure   "Firewall stealth mode enabled"
      else
        increment_insecure "Firewall stealth mode is not enabled"
        lockdown_command   "sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on" "Stealth mode on"
      fi
      check=$( sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getloggingmode | egrep "enabled|on" )
      if [ "$check" ]; then
        increment_secure   "Firewall logging mode enable"
      else
        increment_insecure "Firewall logging mode is not enabled"
        lockdown_command   "sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on" "Logging mode on"
      fi
      check=$( sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getloggingopt | grep detail )
      if [ "$check" ]; then
        increment_secure   "Firewall logging option detailed"
      else
        increment_insecure "Firewall logging option is not detailed"
        lockdown_command   "sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingopt detail" "Logging output detail"
      fi
    fi
  fi
}
