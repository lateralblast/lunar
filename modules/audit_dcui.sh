#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_dcui
#
# Check DCUI
#
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-6779F098-48FE-4E22-B116-A8353D19FF56.html
#.

audit_dcui () {
  if [ "$os_name" = "VMkernel" ]; then
    service_name="DCUI"
    verbose_message     "$service_name Lockdown" "check"
    check_linux_service "$service_name" "off"
    backup_file="$work_dir/dvfilter"
    current_value=$( vim-cmd -U dcui vimsvc/auth/lockdown_is_enabled )
    if [ "$audit_mode" != "2" ]; then
      if [ "$current_value" != "true" ]; then
        if [ "$audit_mode" = "0" ]; then
          echo "$current_value" > "$backup_file"
          verbose_message "DCUI Lockdown to true" "set"
           vim-cmd -U dcui vimsvc/auth/lockdown_mode_enter
        fi
        if [ "$audit_mode" = "1" ]; then
          increment_insecure "DCUI Lockdown is disabled"
          verbose_message    "vim-cmd -U dcui vimsvc/auth/lockdown_mode_enter" "fix"
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          increment_secure "DCUI Lockdown is enabled"
        fi
      fi
    else
      restore_file="$restore_dir/$test"
      if [ -f "$restore_file" ]; then
        previous_value=$( cat "$restore_file" )
        if [ "$previous_value" != "$current_value" ]; then
          verbose_message "DCUI Lockdown to $previous_value" "restore"
          if [ "$previous_value" = "true" ]; then
            vim-cmd -U dcui vimsvc/auth/lockdown_mode_enter
          else
            vim-cmd -U dcui vimsvc/auth/lockdown_mode_exit
          fi
        fi
      fi
    fi
  fi
}
