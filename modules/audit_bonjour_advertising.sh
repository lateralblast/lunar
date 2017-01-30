# audit_bonjour_advertising
#
# Refer to Section 3.4-7     Page(s) 39-40 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 2.4.14.14 Page(s) 62-3  CIS Apple OS X 10.5 Benchmark v1.1.0
#.

audit_bonjour_advertising() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Bonjour Multicast Advertising"
    check_file="/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist"
    temp_file="$temp_dir/mdnsmcast"
    if [ "$audit_mode" = 2 ]; then
      funct_restore_file $check_file $restore_dir
    else
      total=`expr $total + 1`
      echo "Checking:  Bonjour Multicast Advertising is disabled"
      multicast_test=`cat $check_file |grep 'NoMulticastAdvertisements' |wc -l`
      if [ "multicast_test" != "1" ]; then
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Bonjour Multicast Advertising enabled [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "cat $check_file |sed 's,mDNSResponder</string>,&X                <string>-NoMulticastAdvertisements</string>,g' |tr X '\n' > $temp_file" fix
          funct_verbose_message "cat $temp_file > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          cat $check_file |sed 's,mDNSResponder</string>,&X                <string>-NoMulticastAdvertisements</string>,g' |tr X '\n' > $temp_file
          cat $temp_file > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Bonjour Multicast Advertising disabled [$secure Passes]"
        fi
      fi
    fi
    if [ "$osx_mdns_enable" != "yes" ]; then
      funct_launchctl_check com.apple.mDNSResponder off
      funct_launchctl_check com.apple.mDNSResponderHelper off
    fi
  fi
}
