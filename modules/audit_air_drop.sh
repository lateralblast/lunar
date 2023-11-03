# audit_air_drop
#
# AirDrop can allow malicious files to be downloaded from unknown sources. Contacts
# Only limits may expose personal information to devices in the same area.
#
# Refer to Section(s) 2.3.1.1 Page(s) 72-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_air_drop () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Air Drop"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.NetworkBrowser DisableAirDrop 1 bool $user_name
        done
      fi
    fi
  fi
}
