# audit_docker_monitoring
#
# Check Docker monitoring
#
# Refer to Section(s) 4.6  Page(s) 115 CIS Docker Benchmark 1.13.0
# Refer to https://github.com/docker/docker/pull/22719
#.

audit_docker_monitoring () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      docker_bin=`which docker`
      if [ "$docker_bin" ]; then
        funct_verbose_message "Docker Healthcheck"
        docker_ids=`docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}' 2> /dev/null`
        for docker_id in $docker_ids; do
          total=`expr $total + 1`
          check=`docker inspect --format='{{ .Config.Healthcheck }}' $docker_id`
          if [ ! "$check" = "<nil>" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Docker instance $docker_id has a Healthcheck instruction [$secure Passes]"
          else
            insecure=`expr $insecure + 1`
            echo "Warning:   Docker instance $docker_id has no Healthcheck instruction [$insecure Warnings]"
          fi
        done
      fi
    fi
  fi
}
