# audit_remote_apple_events
#
# Refer to Section(s) 5.20  Page(s) 68-9 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 2.4.2 Page(s) 38   CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_remote_apple_events () {
  if [ "$os_name" = "Darwin" ]; then
  	if [ "$os_release" -ge 12 ]; then
      funct_systemsetup_check getremoteappleevents off
  	else
	    funct_verbose_message "Remote Apple Events"
	    funct_launchctl_check eppc
    fi
  fi
}
