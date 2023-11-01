# audit_air_drop
#
# AirDrop can allow malicious files to be downloaded from unknown sources. Contacts
# Only limits may expose personal information to devices in the same area.
#
# Refer to Section(s) 2.3.1.1 Page(s) 72-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_air_drop () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Air Drop"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( sudo -u $user_name defaults read com.apple.NetworkBrowser DisableAirDrop 2>&1 > /dev/null )
          if [ "$check_value" = "$disable_airdrop" ]; then
            increment_secure "Air Drop Disable for $user_name is set to $disable_airdrop"
          else
            increment_insecure "Air Drop Disable for $user_name is not set to $disable_airdrop"
          fi
        done
      fi
    fi
  fi
}
