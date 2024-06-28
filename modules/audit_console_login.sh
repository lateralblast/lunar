#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_console_login
#
# Check console login
#
# Refer to Section(s) 6.4   Page(s) 142-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.4   Page(s) 165   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.4   Page(s) 145   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.5   Page(s) 256   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 9.3.4 Page(s) 134-5 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.14  Page(s) 57    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.10  Page(s) 95-6  CIS Solaris 10 Benchamrk v5.1.0
# Refer to Section(s) 5.5   Page(s) 248   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_console_login () {
  if [ "$os_name" = "SunOS" ]; then
    string="Root Login to System Console"
   verbose_message "$string" "check"
    if [ "$os_version" = "10" ]; then
      check_file="/etc/default/login"
      check_file_value "is" "$check_file" "CONSOLE" "eq" "/dev/console" "hash"
    fi
    if [ "$os_version" = "11" ]; then
      service_name="svc:/system/console-login:terma"
      check_sunos_service "svc:/system/console-login:terma" "disabled"
      service_name="svc:/system/console-login:termb"
      check_sunos_service "$service_name" "disabled"
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/securetty"
    if [ -f "$check_file" ]; then
      string="Root Login to System Console"
      verbose_message "$string" "check"
      disable_ttys=0
      console_list=""
      if [ "$audit_mode" != 2 ]; then
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: $string"
          echo "  lineinfile:"
          echo "    path: $check_file"
          echo "    regexp: '^tty[0-9]"
          echo "    replace: '#\1'"
          echo "  when: ansible_facts['ansible_system'] == '$os_name'"
          echo ""
        fi
        device_list=$( grep '^tty[0-9]' $check_file )
        for console_device in $device_list; do
          disable_ttys=1
          console_list="$console_list $console_device"
        done
        if [ "$disable_ttys" = 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Consoles enabled on \"$console_list\""
            verbose_message    "ed 's/^tty[0-9].*//g' < $check_file | grep '[a-z]' > $temp_file" "fix"
            verbose_message    "cat $temp_file > $check_file" "fix"
            verbose_message    "rm $temp_file" "fix"
          fi
          if [ "$audit_mode" = 0 ]; then
            backup_file     "$check_file"
            verbose_message "Consoles to disabled on \"$console_list\"" "set"
            sed "s/tty[0-9].*//g" < "$check_file" | grep '[a-z]' > "$temp_file"
            cat "$temp_file" > "$check_file"
            rm "$temp_file"
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "No consoles enabled on tty[0-9]*"
          fi
        fi
      else
        restore_file "$check_file" "$restore_dir"
      fi
    fi
  fi
}
