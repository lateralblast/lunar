# audit_firewall_setting
#
# Apple's firewall will protect your computer from certain incoming attacks.
# Apple offers three firewall options: Allow all, Allow only essential, and
# Allow access for specific incoming connections. Unless you have a specific
# need to allow incoming connection (for services such as SSH, file sharing,
# or web services), set the firewall to "Allow only essential services,"
# otherwise use the "allow access for specific incoming connections" option.
#
# 0 = off
# 1 = on for specific services
# 2 = on for essential services
#
# Refer to Sectioni(s) 2.6.4 Page(s) verbose_message "-1 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Sectioni(s) 2.6.3 Page(s) 56-7 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_firewall_setting () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Firewall Settings"
    check_osx_defaults /Library/Preferences/com.apple.alf globalstate 1 int
    if [ "$audit_mode" != 2 ]; then
    	check=$( /usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode | grep enabled )
      if [ "$check" ]; then
        increment_secure "Firewall stealth mode enabled"
      else
        increment_insecure "Firewall stealth mode disabled"
        lockdown_command "sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on"
      fi
    fi
  fi
}
