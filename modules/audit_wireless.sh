# audit_wireless
#
# Wireless checks
#
# Refer to Section(s) 4.2 Page(s) 98-9 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_wireless () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Wifi information menu"
    check=$( defaults read com.apple.systemuiserver menuExtras | grep AirPort.menu | sed "s/[ ,\",\,]//g" )
    if [ "$check" = "/System/Library/CoreServices/MenuExtras/AirPort.menu" ]; then
      increment_secure "Wireless status menu is enabled"
    else
      increment_insecure "Wireless status menu is not enabled"
    fi
  fi
}
