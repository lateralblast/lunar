# audit_docker_daemon
#
# Check that Docker daemon activities are audited
#
# Refer to Section(s) 1.5  Page(s) 18-9  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to Section(s) 1.6  Page(s) 20-1  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to Section(s) 1.7  Page(s) 22-3  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to Section(s) 1.8  Page(s) 24-5  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to Section(s) 1.9  Page(s) 26-7  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to Section(s) 1.10 Page(s) 28-9  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to Section(s) 1.11 Page(s) 30-1  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#daemon-configuration-file
# Refer to Section(s) 1.12 Page(s) 32-3  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://github.com/docker/docker/pull/20662
# Refer to https://containerd.tools/
# Refer to Section(s) 1.13 Page(s) 34-5  CIS Docker Benchmark 1.13.0
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://github.com/docker/docker/pull/20662
# Refer to https://containerd.tools/
# Refer to https://github.com/opencontainers/runc
# Refer to Section(s) 2.4  Page(s) 41-2  CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/registry/insecure/
# Refer to Section(s) 2.5  Page(s) 43-4  CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/reference/commandline/cli/#daemon-storage-driver-option
# Refer to http://muehe.org/posts/switching-docker-from-aufs-to-devicemapper/
# Refer to http://jpetazzo.github.io/assets/2015-03-05-deep-dive-into-docker-storage-drivers.html#1
# Refer to https://docs.docker.com/engine/userguide/storagedriver/
# Refer to Section(s) 2.6  Page(s) 45-6  CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/articles/https/
# Refer to Section(s) 2.7  Page(s) 47-8  CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#default-ulimits
# Refer to Section(s) 2.8  Page(s) 49-50 CIS Docker Benchmark 1.13.0
# Refer to http://man7.org/linux/man-pages/man7/user_namespaces.7.html
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/
# Refer to http://events.linuxfoundation.org/sites/events/files/slides/User%20Namespaces%20-%20ContainerCon%202015%20-%2016-9-final_0.pdf
# Refer to https://github.com/docker/docker/issues/21050
# Refer to Section(s) 2.9  Page(s) 51-2  CIS Docker Benchmark 1.13.0
# Refer to Section(s) 2.10 Page(s) 53    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#storage-driver-options
# Refer to Section(s) 2.11 Page(s) 54-5  CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#access- authorization
# Refer to https://docs.docker.com/engine/extend/authorization/
# Refer to https://github.com/twistlock/authz
# Refer to Section(s) 2.13 Page(s) 58    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/
# Refer to https://github.com/docker/docker/issues/8093
# Refer to https://github.com/docker/docker/issues/9015
# Refer to https://github.com/docker/docker-registry/issues/612
# Refer to https://docs.docker.com/registry/spec/api/
# Refer to https://the.binbashtheory.com/creating-private-docker-registry-2-0-with-token-authentication-service/
# Refer to https://blog.docker.com/2015/07/new-tool-v1-registry-docker-trusted-registry-v2-open-source/
# Refer to http://www.slideshare.net/Docker/docker-registry-v2
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
          docker_file=`systemctl show -p FragmentPath $docker_service 2> /dev/null`
          funct_append_file $check_file "-w $docker_file -k docker" hash
        done
      fi
      funct_dockerd_check unused daemon insecure-registry
      funct_dockerd_check unused daemon storage-driver aufs
      funct_dockerd_check unused info "Storage Driver" aufs
      funct_dockerd_check used daemon tlsverify
      funct_dockerd_check used daemon tlscacert
      funct_dockerd_check used daemon tlscert
      funct_dockerd_check used daemon tlskey
      funct_dockerd_check used daemon default-ulimit
      funct_dockerd_check used daemon cgroup-parent
      funct_dockerd_check used daemon userns-remap
      funct_file_exists /etc/subuid yes
      funct_file_exists /etc/subgid yes
      funct_dockerd_check unused daemon storage-opt
      funct_dockerd_check used daemon authorization-plugin
      funct_dockerd_check unused daemon disable-legacy-registry

    fi
  fi
}
