# audit_bt_sharing
#
# Refer to Section(s) 2.1.1   Page(s) 8-11 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 2.1.1-3 Page(s) 21-5 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_bt_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Bluetooth services and file sharing"
    echo "Checking:  Bluetooth services and file sharing"
    check_osx_defaults /Library/Preferences/com.apple.Bluetooth ControllerPowerState 0 int
    check_osx_defaults /Library/Preferences/com.apple.Bluetooth PANServices 0 int
    check_osx_defaults /Library/Preferences/com.apple.Bluetooth BluetoothSystemWakeEnable 0 bool
    backup_file="bluetooth_discover"
    if [ "$audit_mode" != 2 ]; then
    	if [ "$os_release" -ge 12 ]; then
	    	total=`expr $total + 1`
	    	check=`/usr/sbin/system_profiler SPBluetoothDataType | grep -i power |cut -f2 -d: |sed "s/ //g"`
	    	if [ ! "$check" = "Off" ]; then
	    		check=`/usr/sbin/system_profiler SPBluetoothDataType | grep -i discoverable |cut -f2 -d: |sed "s/ //g"`
	    		if [ "$check" = "Off" ]; then
		    		secure=`expr $secure + 1`
		        echo "Secure:    Bluetooth is not discoverable [$secure Passes]"
	    		else
	    			insecure=`expr $insecure + 1`
	          echo "Warning:   Bluetooth is discoverable [$insecure Warnings]"
	    		fi
	    	else
	    		secure=`expr $secure + 1`
	        echo "Secure:    Bluetooth is turned off [$secure Passes]"
	    	fi
	    	total=`expr $total + 1`
	    	check=`defaults read com.apple.systemuiserver menuExtras | grep Bluetooth.menu | sed "s/[ ,\",\,]//g"`
	  		if [ "$check" = "/System/Library/CoreServices/MenuExtras/Bluetooth.menu" ]; then
	    		secure=`expr $secure + 1`
	        echo "Secure:    Bluetooth status menu is enabled [$secure Passes]"
	   		else
	   			insecure=`expr $insecure + 1`
	        echo "Warning:   Bluetooth status menu is not enabled [$insecure Warnings]"
	      fi
    	fi
    fi
  fi
}
