# audit_air_play
#
# AirDrop can allow malicious files to be downloaded from unknown sources. Contacts
# Only limits may expose personal information to devices in the same area.
#
# Refer to Section(s) 2.3.1.2 Page(s) 77-80 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_air_play () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Air Play Receiver"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.controlcenter.plist AirplayRecieverEnabled 0 bool currentHost $user_name
        done
      fi
    fi
  fi
}
