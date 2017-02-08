# funct_dockerd_check
#
# Check whether a executable, file or directory is being audited
#.

funct_dockerd_check () {
  if [ $os_name = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      used=$1
      type=$2
      param=$3
      value=$4
      total=`expr $total + 1`
      case "$type" in
        "daemon")
          check=`ps -ef |grep dockerd |grep "$param"`
          if [ "$check" ] && [ "$value" ] && [ "$used" = "unused" ]; then
            check=`ps -ef |grep dockerd |grep "$param" |grep "$value"`
            if [ ! "$check" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Docker parameter $param is not set to $value [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Docker parameter $param is set to $value [$secure Passes]"
            fi
          else
            if [ "$used" = "used" ] && [ ! "$check" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Docker parameter $param is not used [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Docker parameter $param is $used [$secure Passes]"
            fi
          fi
          ;;
        "info")
          check=`docker info 2> /dev/null |grep "$param"`
          if [ "$check" ] && [ "$value" ] && [ "$used" = "unused" ]; then
            check=`docker info 2> /dev/null |grep "$param" |grep "$value"`
            if [ ! "$check" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Docker parameter $param is not set to $value [$insecure Warnings]"
            else
              secure=`expr $secure + 1`
              echo "Secure:    Docker parameter $param is set to $value [$secure Passes]"
            fi
          else
            secure=`expr $secure + 1`
            echo "Secure:    Docker parameter $param is $used [$secure Passes]"
          fi
          ;;
      esac
    fi
  fi
}
