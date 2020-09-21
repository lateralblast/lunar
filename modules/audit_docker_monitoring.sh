# audit_docker_monitoring
#
# Check Docker monitoring
#
# Refer to Section(s) 4.6  Page(s) 115 CIS Docker Benchmark 1.13.0
# Refer to https://github.com/docker/docker/pull/22719
# Refer to Section(s) 5.26 Page(s) 172 CIS Docker Benchmark 1.13.0
# Refer to https://github.com/docker/docker/pull/22719
#.

audit_docker_monitoring () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    if [ "$audit_mode" != 2 ]; then
      docker_bin=$( command -v docker )
      if [ "$docker_bin" ]; then
        verbose_message "Docker Healthcheck"
        check_dockerd equal config Health ""
        docker_ids=$( docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}' 2> /dev/null )
        for docker_id in $docker_ids; do
          check=$( docker inspect --format='{{ .Config.Healthcheck }}' $docker_id )
          if [ ! "$check" = "<nil>" ]; then
            increment_secure "Docker instance $docker_id has a Healthcheck instruction"
          else
            increment_insecure "Docker instance $docker_id has no Healthcheck instruction"
          fi
        done
      fi
    fi
  fi
}
