#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_docker_logging
#
# Check Docker logging
#
# Refer to Section(s) 2.2  Page(s) 38   CIS Docker Benchmark 1.13.0
# Refer to Section(s) 2.12 Page(s) 56-7 CIS Docker Benchmark 1.13.0
#
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/
# Refer to https://docs.docker.com/engine/admin/logging/overview/
#.

audit_docker_logging () {
  print_function "audit_docker_logging"
  if [ "${os_name}" = "Linux" ]; then
    docker_bin=$( command -v docker )
    if [ "${docker_bin}" ]; then
      verbose_message "Docker Logging"  "check"
      check_dockerd   "unused" "daemon" "log-level"  "info"
      check_dockerd   "used"   "daemon" "log-driver" ""
      check_dockerd   "used"   "daemon" "log-opt"    ""
    fi
  fi
}
