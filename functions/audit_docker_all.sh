# audit_docker_all
#
# Audit Docker
#
# All the Docker specific tests
#.

audit_docker_all () {
  audit_auditd
  audit_docker_users
  audit_docker_daemon
  audit_docker_network
  audit_docker_logging
  audit_docker_monitoring
  audit_docker_security
}

