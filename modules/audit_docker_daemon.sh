# audit_docker_daemon
#
# Check that Docker daemon activities are audited
#
# Refer to Section(s) 1.5  Page(s) 18-9 CIS Docker Benchmark 1.13.0
# Refer to Section(s) 1.6  Page(s) 20-1 CIS Docker Benchmark 1.13.0
# Refer to Section(s) 1.7  Page(s) 22-3 CIS Docker Benchmark 1.13.0
# Refer to Section(s) 1.8  Page(s) 24-5 CIS Docker Benchmark 1.13.0
# Refer to Section(s) 1.9  Page(s) 26-7 CIS Docker Benchmark 1.13.0
# Refer to Section(s) 1.10 Page(s) 28-9 CIS Docker Benchmark 1.13.0
# Refer to Section(s) 1.11 Page(s) 30-1 CIS Docker Benchmark 1.13.0
# Refer to Section(s) 1.12 Page(s) 32-3 CIS Docker Benchmark 1.13.0
# Refer to Section(s) 1.13 Page(s) 34-5 CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#daemon-configuration-file
# Refer to https://github.com/docker/docker/pull/20662
# Refer to https://containerd.tools/
# Refer to https://github.com/opencontainers/runc
#.

audit_docker_daemon () {
  if [ "$os_name" = "Linux" ]; then
    docker_bin=`which docker`
    if [ "$docker_bin" ]; then
      funct_verbose_message "Docker Daemon"
      check_file="/etc/audit/audit.rules"
      for docker_file in /usr/bin/docker /var/lib/docker /etc/docker /etc/default/docker /etc/docker/daemon.json /usr/bin/docker-containerd /usr/bin/docker-runc; do
        funct_auditctl_check $docker_file
        funct_append_file $check_file "-w $docker_file -k docker" hash
      done
      check=`which systemctl`
      if [ "$check" ]; then
        for docker_service in docker.service docker.socker; do
          funct_auditctl_check $docker_service
          docker_file=`systemctl show -p FragmentPath $docker_service`
          funct_append_file $check_file "-w $docker_file -k docker" hash
        done
      fi
    fi
  fi
}
