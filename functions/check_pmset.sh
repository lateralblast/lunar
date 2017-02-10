# check_pmset
#
# Check Apple Power Management settings
#.

check_pmset() {
  if [ "$os_name" = "Darwin" ]; then
    service=$1
    value=$2
    if [ "$value" = "off" ]; then
      value="0"
    fi
    if [ "$value" = "on" ]; then
      value="1"
    fi
    if [ "$value" = "0" ]; then
      state="off"
    fi
    if [ "$value" = "1" ]; then
      state="on"
    fi
    log_file="pmset_$service.log"
    actual_value=`pmset -g | grep $service |awk '{print $2}' |grep $value`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Sleep is disabled when powered"
      
      if [ ! "$actual_value" = "$value" ]; then
        
        increment_insecure "Service $service is not $state"
        if [ "$audit_mode" = 0 ]; then
          echo "Seting:    Wake on Lan to $state"
          echo "$check" > $work_dir/$log_file
          pmset -c $service $value
        fi
      else
        
        increment_secure "Service $service is $state"
      fi
    else
      restore_file=$retore_dir/$log_file
      if [ -f "$restore_file" ]; then
        $restore_value=`cat $restore_file`
        if [ "$restore_value" != "$actual_value" ]; then
          echo "Restoring: Wake on lan to enabled"
          pmset -c $service $restore_value
        fi
      fi
    fi
  fi
}
