# audit_universal_control
#
# Universal Control is an Apple feature that allows Mac users to control multiple other
# Macs and iPads with the same keyboard, mouse, and trackpad using the same Apple
# ID. The technology relies on already available iCloud services, particularly Handoff.
#
# Refer to Section(s) 2.8.1 Page(s) 194-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_universal_control () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Universal Control"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          for parameter in Disable DisableMagicEdges; do
            check_value=$( sudo -u $user_name defaults read com.apple.universalcontrol $parameter 2>&1 > /dev/null )
            if [ "$check_value" = "$uc_disable" ]; then
              increment_secure "Universal Control setting $parameter for $user_name is set to $uc_disable"
            else
              increment_insecure "Universal Control setting $parameter for $user_name is not set to $uc_disablep"
            fi
          done
        done
      fi
    fi
  fi
}
