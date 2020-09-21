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
    docker_bin=$( command -v docker )
    if [ "$docker_bin" ]; then
      verbose_message "Docker Network"
      backup_file="network_bridge"
      new_state="false"
      old_state="true"
      if [ "$audit_mode" != 2 ]; then
        check_dockerd notequal config NetworkMode "NetworkMode=host"
        check_dockerd notinclude config Ports "0.0.0.0"
        check=$( docker network ls --quiet | xargs docker network inspect --format '{{ .Name }}: {{ .Options }}' | grep 'docker0' )
        if [ "$check" ]; then
          increment_insecure "Docker is using default bridge docker0"
        else
          increment_secure "Docker is not using default bridge docker0"
        fi
        check=$( docker network ls --quiet | xargs docker network inspect --format '{{ .Name }}: {{ .Options }}' | grep 'com.docker.network.bridge.enable_icc' | grep $new_state )
        if [ ! "$check" ]; then
          increment_insecure "Traffic is allowed between containers"
          if [ "$audit_mode" = 0 ]; then
            log_file="$work_dir/$backup_file"
            echo "$old_state" > $log_file
            verbose_message "Setting:   Docker network bridge enabled to $new_state"
            /usr/bin/dockerd --icc=$new_state
          fi
        else
          increment_secure "Traffic is not allowed between containers"
        fi
      else
        restore_file="$restore_dir/$backup_file"
        old_state=$( cat $restore_file )
        verbose_message "Setting:   Docker network bridge enabled to $old_state"
        /usr/bin/dockerd --icc=$old_state
      fi
      check_dockerd unused daemon iptables true
      check_dockerd used daemon opt encrypted
    fi
  fi
}
