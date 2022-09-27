# audit_wireless
#
# Wireless checks
#
# Refer to Section(s) 4.2   Page(s) 98-9  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 3.1.2 Page(s) 177-9 CIS Ubuntu 22.04 Benchmark v1.0.0
#.

audit_wireless () {
  if [ "$os_name" = "Darwin" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Wifi information menu"
    if [ "$os_name" = "Darwin" ]; then
      check=$( defaults read com.apple.systemuiserver menuExtras | grep AirPort.menu | sed "s/[ ,\",\,]//g" )
      answer="/System/Library/CoreServices/MenuExtras/AirPort.menu"
    else
      check=$(nmcli radio all |grep enabled |wc -l)
      answer="0"
    fi
    if [ "$check" = "$answer" ]; then
      increment_secure "Wireless status menu is enabled"
    else
      increment_insecure "Wireless status menu is not enabled"
    fi
  fi
}
