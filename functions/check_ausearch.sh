# check_ausearch
#
# Check what the auditing entries are for a specific command
#.

check_ausearch () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      funct=$1
      bin=$2
      command=$3
      mode=$4
      value=$5 
      exists=`which $bin`
      if [ "$exists" ]; then
        if [ "$value" ]; then
          check=`ausearch -k $bin 2> /dev/null | grep $command | grep $mode |grep "$value"`
          echo "Checking:  Binary $bin has $command commands with option $mode is set to $value"
        else
          check=`ausearch -k $bin 2> /dev/null | grep $command | grep $mode`
          echo "Checking:  Binary $bin has $command commands with option $mode is set"
        fi
        if [ "$funct" = "equal" ]; then
          if [ "$value" ]; then
            if [ ! "$check" ]; then
              increment_insecure "Audit configuration for binary $bin does not have $command commands with option $mode set to $value"
            else
              increment_secure "Audit configuration for binary $bin has $command commands with option $mode set to $value"
            fi
          else
            if [ "$check" ]; then
              increment_insecure "Audit configuration for binary $bin has $command commands with option $mode set"
            else
              increment_secure "Audit configuration for binary $bin does not have $command commands with option $mode set"
            fi
          fi
        else
          if [ "$value" ]; then
            if [ "$check" ]; then
              increment_insecure "Audit configuration for binary $bin has $command commands with option $mode set to $value"
            else
              increment_secure "Audit configuration for binary $bin does not have $command commands with option $mode set to $value"
            fi
          else
            if [ ! "$check" ]; then
              increment_insecure "Audit configuration for binary $bin does not have $command commands with option $mode unset"
            else
              increment_secure "Audit configuration for binary $bin has $command commands with option $mode unset"
            fi
          fi
        fi
      fi
    fi
  fi
}