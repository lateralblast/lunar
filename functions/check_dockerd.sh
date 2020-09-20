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
         verbose_message "Docker $type parameter $param has value $value"
        else
         verbose_message "Docker $type parameter $param has no value"
        fi
      else
        if [ "$value" ]; then
         verbose_message "Docker $type parameter $param is $used and has value $value"
        else
         verbose_message "Docker $type parameter $param is $used"
        fi
      fi
      case "$type" in
        "daemon")
          check=$( ps -ef | grep dockerd | grep "$param" )
          if [ "$check" ] && [ "$value" ] && [ "$used" = "unused" ]; then
            check=$( ps -ef | grep dockerd | grep "$param" | grep "$value" )
            if [ ! "$check" ]; then
              increment_insecure "Docker parameter $param is not set to $value"
            else
              increment_secure "Docker parameter $param is set to $value"
            fi
          else
            if [ "$used" = "used" ] && [ ! "$check" ]; then
              
              increment_insecure "Docker parameter $param is not used"
            else
              
              increment_secure "Docker parameter $param is $used"
            fi
          fi
          ;;
        "info")
          check=$( docker info 2> /dev/null |grep "$param" )
          if [ "$check" ] && [ "$value" ] && [ "$used" = "unused" ]; then
            check=$( docker info 2> /dev/null | grep "$param" | grep "$value" )
            if [ ! "$check" ]; then
              increment_insecure "Docker parameter $param is not set to $value"
            else
              increment_secure "Docker parameter $param is set to $value"
            fi
          else
            increment_secure "Docker parameter $param is $used"
          fi
          ;;
        "kernel")
          OFS=$IFS
          IFS=$'\n'
          docker_info=$( docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: CapAdd={{ .HostConfig.CapAdd }}' 2> /dev/null )
          if [ ! "$docker_info" ]; then
            verbose_message "Notice:    No Docker instances"
          fi
          for info in $docker_info; do
            docker_id=$( echo "$info" | cut -f1 -d: )
            check=$( echo "$info" | cut -f2 -d: | cut -f2 -d= | grep "$param" )
            if [ "$used" = "used" ]; then
              if [ "$profile" ]; then
                increment_secure "Docker instance $docker_id has capability $param"
              else
                increment_insecure "Docker instance $docker_id does not have capability $param"
              fi
            else
              if [ "$profile" ]; then
                increment_secure "Docker instance $docker_id does not have capability $param"
              else
                increment_insecure "Docker instance $docker_id has capability $param"
              fi
              check=$( docker inspect --format '{{ .Id }}: CapAdd={{ .HostConfig.CapDrop }}' $docker_id | cut -f2 -d= | grep "$param" )
              if [ "$check" ]; then
                increment_secure "Docker instance $docker_id forcibly drops capability $param"
              else
                increment_insecure "Docker instance $docker_id does not forcibly capability $param"
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
              docker_info=$( docker ps --quiet --all | xargs docker inspect --format "{{ .Id }}: $param={{ .$param }}" 2> /dev/null )
              ;;
            "User")
              docker_info=$( docker ps --quiet --all | xargs docker inspect --format "{{ .Id }}: $param={{ .Config.$param }}" 2> /dev/null )
              ;;
            "Ports")
              docker_info=$( docker ps --quiet --all | xargs docker inspect --format "{{ .Id }}: $param={{ .NetworkSettings.$param }}" 2> /dev/null )
              ;;
            "Propagation")
              docker_info=$( docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: Propagation={{range $mnt := .Mounts}} {{json $mnt.Propagation}} {{end}}' 2> /dev/null )
              ;;
            "Health")
              docker_info=$( docker ps --quiet | xargs docker inspect --format '{{ .Id }}: Health={{ .State.Health.Status }}' 2> /dev/null )
              ;;
            *)
              docker_info=$( docker ps --quiet --all | xargs docker inspect --format "{{ .Id }}: $param={{ .HostConfig.$param }}" 2> /dev/null )
              ;;
          esac
          if [ ! "$docker_info" ]; then
            verbose_message "Notice:    No Docker instances with $param set"
          fi
          for info in $docker_info; do
            docker_id=$( echo "$info" | cut -f1 -d: )
            case $used in
              "notequal")
                profile=$( echo "$info" | cut -f2 -d: | cut -f2 -d= | grep -v "\[\]" )
                if [ ! "$value" ]; then
                  if [ "$profile" ]; then
                    increment_secure "Docker instance $docker_id does not have parameter $param set"
                  else
                    increment_insecure "Docker instance $docker_id has parameter $param set"
                  fi
                else
                  if [ ! "$profile" = "$value" ]; then
                    increment_secure "Docker instance $docker_id does not have parameter $param set to $value"
                  else
                    increment_insecure "Docker instance $docker_id has parameter $param set to $value"
                  fi
                fi
                ;;
              "equal")
                profile=$( echo "$info" | cut -f2 -d: | cut -f2 -d= | grep -v "\[\]" )
                if [ ! "$value" ]; then
                  if [ ! "$profile" ]; then
                    increment_secure "Docker instance $docker_id does not have parameter $param set"
                  else
                    increment_insecure "Docker instance $docker_id has parameter $param set"
                  fi
                else
                  if [ "$profile" = "$value" ]; then
                    increment_secure "Docker instance $docker_id does not have parameter $param set to $value"
                  else
                    increment_insecure "Docker instance $docker_id does not have parameter $param set to $value"
                  fi
                fi
                ;;
              "notinclude")
                profile=$( echo "$info" | cut -f2 -d: | cut -f2 -d= | grep "$param" )
                if [ ! "$profile" ]; then
                  increment_secure "Docker instance $docker_id parameter $param does not include $value"
                else
                  increment_insecure "Docker instance $docker_id parameter $param includes $value"
                fi
                ;; 
              "include")
                profile=$( echo "$info" | cut -f2 -d: | cut -f2 -d= | grep "$param" )
                if [ "$profile" ]; then
                  increment_secure "Docker instance $docker_id parameter $param includes $value"
                else
                  increment_insecure "Docker instance $docker_id parameter $param does not include $value"
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
