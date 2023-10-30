# audit_air_play
#
# AirDrop can allow malicious files to be downloaded from unknown sources. Contacts
# Only limits may expose personal information to devices in the same area.
#
# Refer to Section(s) 2.3.1.2 Page(s) 77-80 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_air_play() {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Air PLay Receiver"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( sudo -u $user_name defaults -currentHost read com.apple.controlcenter.plist AirplayRecieverEnabled )
          if [ "$check_value" = "$enable_airplay" ]; then
            increment_secure "Air PLay Receiver for $user_name is set to $enable_airplay"
          else
            increment_insecure "Air Play Receiver for $user_name is not set to $enable_airplay"
          fi
        done
      fi
    fi
  fi
}
