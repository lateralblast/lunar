# audit_docker_daemon
#
# Check that Docker daemon activities are audited
#
# Refer to Section(s) 1.5 Page(s) 18-9 CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
#.

audit_docker_daemon () {
  if [ "$os_name" = "Linux" ]; then
    docker_bin=`which docker`
    if [ "$docker_bin" ]; then
      funct_verbose_message "Docker Daemon"
      check_file="/usr/bin/docker"
      funct_auditctl_check $check_file
      check_file="/etc/audit/audit.rules"
      funct_append_file $check_file "-w /usr/bin/docker -k docker" hash
    fi
  fi
}
