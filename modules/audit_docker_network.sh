# audit_docker_network
#
# Check that Docker does not allow communication between containers
#
# Refer to Section(s) 2.1  Page(s) 36-7  CIS Docker Benchmark 1.13.0
# Refer to Section(s) 2.3  Page(s) 39-40 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/networking
# Refer to Section(s) 2.19 Page(s) 69    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/userguide/networking/overlay-security-model/
# Refer to https://github.com/docker/docker/issues/24253
# Refer to Section(s) 5.13 Page(s) 148-9 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/networking/#binding-container-ports-to-the-host
# Refer to Section(s) 5.29 Page(s) 177   CIS Docker Benchmark 1.13.0
# Refer to https://github.com/nyantec/narwhal
# Refer to https://arxiv.org/pdf/1501.02967
# Refer to https://docs.docker.com/engine/userguide/networking/dockernetworks/
#.

audit_docker_network () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    docker_bin=`which docker`
    if [ "$docker_bin" ]; then
      funct_verbose_message "Docker Network"
      backup_file="network_bridge"
      new_state="false"
      old_state="true"
      total=`expr $total + 1`
      if [ "$audit_mode" != 2 ]; then
        funct_dockerd_check notequal config NetworkMode "NetworkMode=host"
        funct_dockerd_check notinclude config Ports "0.0.0.0"
        total=`expr $total + 1`
        echo "Checking:  Docker default bridge"
        check=`docker network ls --quiet | xargs docker network inspect --format '{{ .Name }}: {{ .Options }}' |grep 'docker0'`
        if [ "$check" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Docker is using default bridge docker0 [$insecure Warnings]"
        else
          secure=`expr $secure + 1`
          echo "Secure:    Docker is not using default bridge docker0 [$secure Passes]"
        fi
        total=`expr $total + 1`
        check=`docker network ls --quiet | xargs docker network inspect --format '{{ .Name }}: {{ .Options }}' |grep 'com.docker.network.bridge.enable_icc' |grep $new_state`
        echo "Checking:  Docker network bridge traffic setting"
        if [ ! "$check" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Traffic is allowed between containers [$insecure Warnings]"
          if [ "$audit_mode" = 0 ]; then
            log_file="$work_dir/$backup_file"
            echo "$old_state" > $log_file
            echo "Setting:   Docker network bridge enabled to $new_state"
            /usr/bin/dockerd --icc=$new_state
          fi
        else
          secure=`expr $secure + 1`
          echo "Secure:    Traffic is not allowed between containers [$secure Passes]"
        fi
      else
        restore_file="$restore_dir/$backup_file"
        old_state=`cat $restore_file`
        echo "Setting:   Docker network bridge enabled to $old_state"
        /usr/bin/dockerd --icc=$old_state
      fi
      funct_dockerd_check unused daemon iptables true
      funct_dockerd_check used daemon opt encrypted
    fi
  fi
}
