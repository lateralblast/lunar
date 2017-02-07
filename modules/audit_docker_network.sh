# audit_docker_network
#
# Check that Docker does not allow communication between containers
#
# Refer to Section(s) 2.1  Page(s) 36-7  CIS Docker Benchmark 1.13.0
# Refer to Section(s) 2.3  Page(s) 39-40 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/networking
# Refer to Section(s) 2.19 Page(s) 69    CIS Docker Benchmark 1.13.0
#.

audit_docker_network () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Docker Network"
    backup_file="network_bridge"
    new_state="false"
    old_state="true"
    if [ "$audit_mode" != 2 ]; then
      check=`docker network ls --quiet | xargs docker network inspect --format '{{ .Name }}: {{ .Options }}' |grep 'com.docker.network.bridge.enable_icc' |grep $new_state`
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
}
