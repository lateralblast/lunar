# audit_bt_sharing
#
# Bluetooth can be very useful, but can also expose a Mac to certain risks.
# Unless specifically needed and configured properly, Bluetooth should be
# turned off.
# Bluetooth internet sharing can expose a Mac and the network to certain
# risks and should be turned off.
# Unless you are using a Bluetooth keyboard or mouse in a secure environment,
# there is no reason to allow Bluetooth devices to wake the computer.
# An attacker could use a Bluetooth device to wake a computer and then
# attempt to gain access.
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
