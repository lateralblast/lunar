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
# Refer to Section(s) 5.21 Page(s) 164-5  CIS Docker Benchmark 1.13.0
# Refer to http://blog.scalock.com/new-docker-security-features-and-what-they-mean-seccomp-profiles
# Refer to https://docs.docker.com/engine/reference/run/
# Refer to https://github.com/docker/docker/blob/master/profiles/seccomp/default.json
# Refer to https://docs.docker.com/engine/security/seccomp/
# Refer to https://www.kernel.org/doc/Documentation/prctl/seccomp_filter.txt
# Refer to https://github.com/docker/docker/issues/22870
# Refer to Section(s) 5.22 Page(s) 166    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/exec/
# Refer to Section(s) 5.23 Page(s) 167    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/exec/
# Refer to Section(s) 5.24 Page(s) 168-9  CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/run/#specifying-custom-cgroups
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Resource_Management_Guide/ch01.html
# Refer to Section(s) 2.8  Page(s) 49-50  CIS Docker Benchmark 1.13.0
# Refer to http://man7.org/linux/man-pages/man7/user_namespaces.7.html
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/
# Refer to http://events.linuxfoundation.org/sites/events/files/slides/User%20Namespaces%20-%20ContainerCon%202015%20-%2016-9-final_0.pdf
# Refer to https://github.com/docker/docker/issues/21050
# Refer to Section(s) 5.25 Page(s) 170-1  CIS Docker Benchmark 1.13.0
# Refer to https://github.com/projectatomic/atomic-site/issues/269 
# Refer to https://github.com/docker/docker/pull/20727
# Refer to https://www.kernel.org/doc/Documentation/prctl/no_new_privs.txt
# Refer to https://lwn.net/Articles/475678/
# Refer to https://lwn.net/Articles/475362/
#.

audit_docker_security () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    docker_bin=`which docker`
    if [ "$docker_bin" ]; then
      funct_verbose_message "Docker Security"
      funct_dockerd_check notequal config SecurityOpt "<no value>"
      funct_dockerd_check include config SecurityOpt "userns"
      funct_dockerd_check include config SecurityOpt "no-new-privileges"
      funct_dockerd_check equal config Privileged "false"
      funct_dockerd_check notequal config AppArmorProfile ""
      funct_dockerd_check equal config ReadonlyRootfs "true"
      funct_dockerd_check notequal config PidMode "host"
      funct_dockerd_check notequal config IpcMode "host"
      funct_dockerd_check equal config Devices ""
      funct_dockerd_check equal config Ulimits "<no value>"
      funct_dockerd_check notequal config Propagation "shared"
      funct_dockerd_check notequal config UTSMode "shared"
      funct_ausearch_check equal docker exec privileged ""
      funct_ausearch_check equal docker exec user ""
      funct_dockerd_check equal config CgroupParent ""
      for param in NET_ADMIN SYS_ADMIN SYS_MODULE; do
        funct_dockerd_check unused kernel $param
      done
    fi
  fi
}
