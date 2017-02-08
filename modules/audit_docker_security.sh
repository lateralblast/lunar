# audit_docker_security
#
# Docker security
#
# Refer to Section(s) 5.1  Page(s) 126-7 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/security/apparmor/
# Refer to http://docs.docker.com/articles/security/#other-kernel-security-features
# Refer to https://github.com/docker/docker/blob/master/docs/security/apparmor.md
# Refer to http://docs.docker.com/reference/run/#security-configuration
# Refer to Section(s) 5.2  Page(s) 128-9 CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/articles/security/#other-kernel-security-features
# Refer to http://docs.docker.com/reference/run/#security-configuration
# Refer to http://docs.fedoraproject.org/en-US/Fedora/13/html/Security-Enhanced_Linux/
# Refer to Section(s) 5.3  Page(s) 130-1 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/security/#linux-kernel-capabilities
# Refer to https://github.com/docker/docker/blob/master/daemon/execdriver/native/template/default_template.go
# Refer to http://man7.org/linux/man-pages/man7/capabilities.7.html
# Refer to http://www.oreilly.com/webops-perf/free/files/docker-security.pdf
# Refer to Section(s) 5.4  Page(s) 132   CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/reference/commandline/cli
# Refer to Section(s) 5.9  Page(s) 141   CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/articles/networking/#how-docker-networks-a-container
# Refer to https://github.com/docker/docker/issues/6401
# Refer to Section(s) 5.12 Page(s) 146-7 CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/reference/commandline/cli/#run
# Refer to Section(s) 5.15 Page(s) 152-3  CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/reference/run/#pid-settings
# Refer to http://man7.org/linux/man-pages/man7/pid_namespaces.7.html
# Refer to Section(s) 5.16 Page(s) 154-5  CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/reference/run/#pid-settings
# Refer to http://man7.org/linux/man-pages/man7/pid_namespaces.7.html
# Refer to Section(s) 5.17 Page(s) 156-7  CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/reference/commandline/cli/#run
# Refer to Section(s) 5.17 Page(s) 158-9  CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/reference/commandline/cli/#setting-ulimits-in-a-container
# Refer to http://www.oreilly.com/webops-perf/free/files/docker-security.pdf
# Refer to Section(s) 5.19 Page(s) 160-1  CIS Docker Benchmark 1.13.0
# Refer to https://github.com/docker/docker/pull/17034
# Refer to https://docs.docker.com/engine/reference/run/
# Refer to https://www.kernel.org/doc/Documentation/filesystems/sharedsubtree.txt
# Refer to Section(s) 5.20 Page(s) 162-3  CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/run/
# Refer to http://man7.org/linux/man-pages/man7/namespaces.7.html
#.

audit_docker_security () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    docker_bin=`which docker`
    if [ "$docker_bin" ]; then
      funct_verbose_message "Docker Security"
      if [ "$audit_mode" != 2 ]; then
        funct_dockerd_check notequal config SecurityOpt "<no value>"
        funct_dockerd_check equal config Privileged "false"
        funct_dockerd_check notequal config AppArmorProfile ""
        funct_dockerd_check equal config ReadonlyRootfs "true"
        funct_dockerd_check notequal config PidMode "host"
        funct_dockerd_check notequal config IpcMode "host"
        funct_dockerd_check equal config Devices ""
        funct_dockerd_check equal config Ulimits "<no value>"
        funct_dockerd_check notequal config Propagation "shared"
        funct_dockerd_check notequal config UTSMode "shared"
      fi
      for param in NET_ADMIN SYS_ADMIN SYS_MODULE; do
        funct_dockerd_check unused kernel $param
      done
    fi
  fi
}
