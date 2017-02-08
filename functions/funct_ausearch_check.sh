# funct_ausearch_check
#
# Check what the auditing entries are for a specific command
#.

funct_ausearch_check () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      funct=$1
      bin=$2
      command=$3
      mode=$4
      value=$5 
      exists=`which $bin`
      if [ "$exists" ]; then
        total=`expr $total + 1`
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
              insecure=`expr $insecure + 1`
              echo "Warning:   Audit configuration for binary $bin does not have $command commands with option $mode set to $value [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Audit configuration for binary $bin has $command commands with option $mode set to $value [$secure Passes]"
            fi
          else
            if [ "$check" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Audit configuration for binary $bin has $command commands with option $mode set [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Audit configuration for binary $bin does not have $command commands with option $mode set [$secure Passes]"
            fi
          fi
        else
          if [ "$value" ]; then
            if [ "$check" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Audit configuration for binary $bin has $command commands with option $mode set to $value [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Audit configuration for binary $bin does not have $command commands with option $mode set to $value [$secure Passes]"
            fi
          else
            if [ ! "$check" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Audit configuration for binary $bin does not have $command commands with option $mode unset [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Audit configuration for binary $bin has $command commands with option $mode unset [$secure Passes]"
            fi
          fi
        fi
      fi
    fi
  fi
}