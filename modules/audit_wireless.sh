# audit_wireless
#
# Wireless checks
#
# Refer to Section(s) 4.2   Page(s) 98-9  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 3.1.2 Page(s) 177-9 CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 2.4.1 Page(s) 133-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_wireless () {
  if [ "$os_name" = "Darwin" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Wifi information menu"
    if [ "$os_name" = "Darwin" ] && [ "$os_version" -ge 14 ]; then
      for user_name in `ls /Users |grep -v Shared`; do
        check_value=$( sudo -u $user_name defaults -currentHost read com.apple.controlcenter.plist DisableAirDrop 2>&1 )
        if [ "$check_value" = "$wifi_status" ]; then
          increment_secure "Wi-Fi status in Menu Bar for $user_name is set to $wifi_status"
        else
          increment_insecure "Wi-Fi status in Menu Bar for $user_name is not set to $wifi_status"
        fi
      done
    else
      if [ "$os_name" = "Darwin" ]; then
        check=$( defaults read com.apple.systemuiserver menuExtras | grep AirPort.menu | sed "s/[ ,\",\,]//g" )
        answer="/System/Library/CoreServices/MenuExtras/AirPort.menu"
      else
        check=$( command -v nmcli 2> /dev/null )
        if [ "$check" ]; then
          check=$(nmcli radio all |grep enabled |wc -l)
        fi
        answer="0"
      fi
      if [ "$check" = "$answer" ]; then
        increment_secure "Wireless status menu is enabled"
      else
        increment_insecure "Wireless status menu is not enabled"
      fi
    fi
  fi
}
