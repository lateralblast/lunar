# audit_bt_sharing
#
# Refer to Section 2.1.1 Page(s) 8-11 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_bt_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Bluetooth services and file sharing"
    funct_defaults_check /Library/Preferences/com.apple.Bluetooth ControllerPowerState 0 int
    funct_defaults_check /Library/Preferences/com.apple.Bluetooth PANServices 0 int
    funct_defaults_check /Library/Preferences/com.apple.Bluetooth BluetoothSystemWakeEnable 0 bool
  fi
}
