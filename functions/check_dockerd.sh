# check_dockerd
#
# Check whether a executable, file or directory is being audited
#.

check_dockerd () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    if [ "$audit_mode" != 2 ]; then
      used=$1
      type=$2
      param=$3
      value=$4
      if [ "$type" = "config" ]; then
        if [ "$value" ]; then
          echo "Checking:  Docker $type parameter $param has value $value"
        else
          echo "Checking:  Docker $type parameter $param has no value"
        fi
      else
        if [ "$value" ]; then
          echo "Checking:  Docker $type parameter $param is $used and has value $value"
        else
          echo "Checking:  Docker $type parameter $param is $used"
        fi
      fi
      case "$type" in
        "daemon")
          total=`expr $total + 1`
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
          total=`expr $total + 1`
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
        "kernel")
          OFS=$IFS
          IFS=$'\n'
          docker_info=`docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: CapAdd={{ .HostConfig.CapAdd }}' 2> /dev/null`
          if [ ! "$docker_info" ]; then
            echo "Notice:    No Docker instances"
          fi
          for info in $docker_info; do
            total=`expr $total + 1`
            docker_id=`echo "$info" |cut -f1 -d:`
            check=`echo "$info" |cut -f2 -d: |cut -f2 -d= |grep "$param"`
            if [ "$used" = "used" ]; then
              if [ "$profile" ]; then
                secure=`expr $secure + 1`
                echo "Secure:    Docker instance $docker_id has capability $param [$secure Passes]"
              else
                insecure=`expr $insecure + 1`
                echo "Warning:   Docker instance $docker_id does not have capability $param [$insecure Warnings]"
              fi
            else
              if [ "$profile" ]; then
                secure=`expr $secure + 1`
                echo "Secure:    Docker instance $docker_id does not have capability $param [$secure Passes]"
              else
                insecure=`expr $insecure + 1`
                echo "Warning:   Docker instance $docker_id has capability $param [$insecure Warnings]"
              fi
              total=`expr $total + 1`
              check=`docker inspect --format '{{ .Id }}: CapAdd={{ .HostConfig.CapDrop }}' $docker_id |cut -f2 -d= |grep "$param"`
              if [ "$check" ]; then
                secure=`expr $secure + 1`
                echo "Secure:    Docker instance $docker_id forcibly drops capability $param [$secure Passes]"
              else
                insecure=`expr $insecure + 1`
                echo "Warning:   Docker instance $docker_id does not forcibly capability $param [$insecure Warnings]"
              fi
            fi
          done
          IFS=$OFS
          ;;
        "config")
          OFS=$IFS
          IFS=$'\n'
          case $param in
            "AppArmorProfile")
              docker_info=`docker ps --quiet --all | xargs docker inspect --format "{{ .Id }}: $param={{ .$param }}" 2> /dev/null`
              ;;
            "User")
              docker_info=`docker ps --quiet --all | xargs docker inspect --format "{{ .Id }}: $param={{ .Config.$param }}" 2> /dev/null`
              ;;
            "Ports")
              docker_info=`docker ps --quiet --all | xargs docker inspect --format "{{ .Id }}: $param={{ .NetworkSettings.$param }}" 2> /dev/null`
              ;;
            "Propagation")
              docker_info=`docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: Propagation={{range $mnt := .Mounts}} {{json $mnt.Propagation}} {{end}}' 2> /dev/null`
              ;;
            "Health")
              docker_info=`docker ps --quiet | xargs docker inspect --format '{{ .Id }}: Health={{ .State.Health.Status }}' 2> /dev/null`
              ;;
            *)
              docker_info=`docker ps --quiet --all | xargs docker inspect --format "{{ .Id }}: $param={{ .HostConfig.$param }}" 2> /dev/null`
              ;;
          esac
          if [ ! "$docker_info" ]; then
            echo "Notice:    No Docker instances with $param set"
          fi
          for info in $docker_info; do
            total=`expr $total + 1`
            docker_id=`echo "$info" |cut -f1 -d:`
            case $used in
              "notequal")
                profile=`echo "$info" |cut -f2 -d: |cut -f2 -d= |grep -v "\[\]"`
                if [ ! "$value" ]; then
                  if [ "$profile" ]; then
                    secure=`expr $secure + 1`
                    echo "Secure:    Docker instance $docker_id does not have parameter $param set [$secure Passes]"
                  else
                    insecure=`expr $insecure + 1`
                    echo "Warning:   Docker instance $docker_id has parameter $param set [$insecure Warnings]"
                  fi
                else
                  if [ ! "$profile" = "$value" ]; then
                    secure=`expr $secure + 1`
                    echo "Secure:    Docker instance $docker_id does not have parameter $param set to $value [$secure Passes]"
                  else
                    insecure=`expr $insecure + 1`
                    echo "Warning:   Docker instance $docker_id has parameter $param set to $value [$insecure Warnings]"
                  fi
                fi
                ;;
              "equal")
                profile=`echo "$info" |cut -f2 -d: |cut -f2 -d= |grep -v "\[\]"`
                if [ ! "$value" ]; then
                  if [ ! "$profile" ]; then
                    secure=`expr $secure + 1`
                    echo "Secure:    Docker instance $docker_id does not have parameter $param set [$secure Passes]"
                  else
                    insecure=`expr $insecure + 1`
                    echo "Warning:   Docker instance $docker_id has parameter $param set [$insecure Warnings]"
                  fi
                else
                  if [ "$profile" = "$value" ]; then
                    secure=`expr $secure + 1`
                    echo "Secure:    Docker instance $docker_id does not have parameter $param set to $value [$secure Passes]"
                  else
                    insecure=`expr $insecure + 1`
                    echo "Warning:   Docker instance $docker_id does not have parameter $param set to $value [$insecure Warnings]"
                  fi
                fi
                ;;
              "notinclude")
                profile=`echo "$info" |cut -f2 -d: |cut -f2 -d= |grep "$param"`
                if [ ! "$profile" ]; then
                  secure=`expr $secure + 1`
                  echo "Secure:    Docker instance $docker_id parameter $param does not include $value [$secure Passes]"
                else
                  insecure=`expr $insecure + 1`
                  echo "Warning:   Docker instance $docker_id parameter $param includes $value [$insecure Warnings]"
                fi
                ;; 
              "include")
                profile=`echo "$info" |cut -f2 -d: |cut -f2 -d= |grep "$param"`
                if [ "$profile" ]; then
                  secure=`expr $secure + 1`
                  echo "Secure:    Docker instance $docker_id parameter $param includes $value [$secure Passes]"
                else
                  insecure=`expr $insecure + 1`
                  echo "Warning:   Docker instance $docker_id parameter $param does not include $value [$insecure Warnings]"
                fi
                ;; 
            esac 
          done
          IFS=$OFS
          ;;
      esac
    fi
  fi
}
