# audit_docker_logging
#
# Check Docker logging
#
# Refer to Section(s) 2.2  Page(s) 38 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/
#.

audit_docker_logging () {
  if [ "$os_name" = "Linux" ]; then
    docker_bin=`which docker`
    if [ "$docker_bin" ]; then
      funct_verbose_message "Docker Logging"
      funct_dockerd_check unused log-level info
    fi
  fi
}
