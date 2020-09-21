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
# Refer to Section(s) 1.11 Page(s) verbose_message "-1  CIS Docker Benchmark 1.13.0
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
# Refer to Section(s) 2.14 Page(s) 60-1  CIS Docker Benchmark 1.13.0
# Refer to https://github.com/docker/docker/pull/23213
# Refer to Section(s) 2.18 Page(s) 67-8  CIS Docker Benchmark 1.13.0
# Refer to http://windsock.io/the-docker-proxy/
# Refer to https://github.com/docker/docker/issues/14856
# Refer to https://github.com/docker/docker/issues/22741
# Refer to https://docs.docker.com/engine/userguide/networking/default_network/binding/
# Refer to Section(s) 2.20 Page(s) 70-1  CIS Docker Benchmark 1.13.0
# Refer to https://github.com/docker/docker/pull/26276
# Refer to Section(s) 2.21 Page(s) 72    CIS Docker Benchmark 1.13.0
# Refer to https://github.com/docker/docker/issues/26713
# Refer to https://github.com/docker/docker/pull/27223
# Refer to Section(s) 2.23 Page(s) 74-5  CIS Docker Benchmark 1.13.0
# Refer to https://github.com/mstanleyjones/docker.github.io/blob/af7dfdba8504f9b102fb31a78cd08a06c33a8975/engine/swarm/swarm_manager_locking.md
# Refer to Section(s) 3.1  Page(s) 77-8   CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/admin/systemd/
# Refer to Section(s) 3.2  Page(s) 79-80  CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/admin/systemd/
# Refer to Section(s) 3.3  Page(s) 81-2   CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/basics/#bind-docker-to-another-hostport-or-a-unix-socket
# Refer to https://github.com/YungSang/fedora-atomic-packer/blob/master/oem/docker.socket
# Refer to http://daviddaeschler.com/2014/12/14/centos-7rhel-7-and-docker-containers-on-boot/
# Refer to Section(s) 3.4 Page(s) 83-4   CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/basics/#bind-docker-to-another-hostport-or-a-unix-socket
# Refer to https://github.com/YungSang/fedora-atomic-packer/blob/master/oem/docker.socket
# Refer to http://daviddaeschler.com/2014/12/14/centos-7rhel-7-and-docker-containers-on-boot/
# Refer to Section(s) 3.5  Page(s) 85     CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to Section(s) 3.6  Page(s) 86     CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to Section(s) 3.7  Page(s) 87-8   CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to http://docs.docker.com/reference/commandline/cli/#insecure-registries
# Refer to Section(s) 3.8  Page(s) 89     CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to http://docs.docker.com/reference/commandline/cli/#insecure-registries
# Refer to Section(s) 3.9  Page(s) 90     CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to http://docs.docker.com/articles/https/
# Refer to Section(s) 3.10 Page(s) 91     CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to http://docs.docker.com/articles/https/
# Refer to Section(s) 3.11 Page(s) 92-3   CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to http://docs.docker.com/articles/https/
# Refer to Section(s) 3.12 Page(s) 94     CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to http://docs.docker.com/articles/https/
# Refer to Section(s) 3.13 Page(s) 95-6   CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to http://docs.docker.com/articles/https/
# Refer to Section(s) 3.14 Page(s) 97     CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/certificates/
# Refer to http://docs.docker.com/articles/https/
# Refer to Section(s) 3.15 Page(s) 98-9   CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/reference/commandline/cli/#daemon-socket-option
# Refer to https://docs.docker.com/articles/basics/#bind-docker-to-another-hostport-or-a-unix-socket
# Refer to Section(s) 3.16 Page(s) 100    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/reference/commandline/cli/#daemon-socket-option
# Refer to https://docs.docker.com/articles/basics/#bind-docker-to-another-hostport-or-a-unix-socket
# Refer to Section(s) 3.17 Page(s) 101    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#daemon-configuration-file
# Refer to Section(s) 3.18 Page(s) 102    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#daemon-configuration-file
# Refer to Section(s) 3.19 Page(s) 103    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/admin/configuring/
# Refer to Section(s) 3.20 Page(s) 104    CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/admin/configuring/
# Refer to Section(s) 5.10 Page(s) 142-3  CIS Docker Benchmark 1.13.0
# Refer to https://goldmann.pl/blog/2014/09/11/resource-management-in-docker/
# Refer to http://docs.docker.com/reference/commandline/cli/#run
# Refer to https://docs.docker.com/articles/runmetrics/
# Refer to Section(s) 5.11 Page(s) 144-5  CIS Docker Benchmark 1.13.0
# Refer to https://goldmann.pl/blog/2014/09/11/resource-management-in-docker/
# Refer to http://docs.docker.com/reference/commandline/cli/#run
# Refer to https://docs.docker.com/articles/runmetrics/
# Refer to Section(s) 5.14 Page(s) 150-1  CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/reference/commandline/cli/#restart-policies
#.

audit_docker_daemon () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    docker_bin=$( command -v docker )
    if [ "$docker_bin" ]; then
      verbose_message "Docker Daemon"
      check_file="/etc/audit/audit.rules"
      for docker_file in /usr/bin/docker /var/lib/docker /etc/docker /etc/default/docker /etc/docker/daemon.json /usr/bin/docker-containerd /usr/bin/docker-runc; do
        check_auditctl $docker_file "docker_file"
        check_append_file $check_file "-w $docker_file -k docker" hash
      done
      check=$( command -v systemctl )
      if [ "$check" ]; then
        for docker_service in docker.service docker.socket; do
          check_auditctl $docker_service "docker_service"
          docker_file=$( systemctl show -p FragmentPath $docker_service 2> /dev/null )
          check_append_file $check_file "-w $docker_file -k docker" hash
          check_file_perms $check_file 0640 root root
        done
      fi
      for check_file in /etc/docker /etc/docker/certs.d; do
        check_file_perms $check_file 0750 root root
      done
      if [ -e "/etc/docker/certs.d" ]; then
        for check_file in $( ls /etc/docker/certs.d/ ); do
          check_file_perms $check_file 440 root root
        done
      fi
      check_file_perms /var/run/docker.sock 660 root docker
      for check_file in /etc/default/docker /etc/docker/daemon.json; do
        check_file_perms $check_file 640 root root
      done
      tlscert_file=""
      tlscacert_file=""
      tlskey_file=""
      for check_file in $tlscert_file $tlscacert_file $tlskey_file; do
        check_file_perms $check_file 400 root root
      done
      check_dockerd unused daemon insecure-registry
      check_dockerd unused daemon storage-driver aufs
      check_dockerd unused daemon net host
      check_dockerd unused info "Storage Driver" aufs
      check_dockerd used daemon tlsverify
      check_dockerd used daemon tlscacert
      check_dockerd used daemon tlscert
      check_dockerd used daemon tlskey
      check_dockerd used daemon default-ulimit
      check_dockerd used daemon cgroup-parent
      check_dockerd used daemon userns-remap
      check_file_exists /etc/subuid yes
      check_file_exists /etc/subgid yes
      check_dockerd unused daemon storage-opt
      check_dockerd used daemon authorization-plugin
      check_dockerd used daemon disable-legacy-registry
      check_dockerd used daemon live-restore
      check_dockerd used daemon userland-proxy false
      check_dockerd used daemon seccomp-profile
      check_dockerd unused daemon experimental
      if [ "$audit_mode" != 2 ]; then
        check=$( docker swarm unlock-key 2> /dev/null )
        if [ "$check" = "no unlock key is set" ]; then
          increment_insecure "Docker swarm unlock is not set"
        else
          increment_secure "Docker swarm unlock key is not set or swarm is not running"
        fi
        check_dockerd notequal config Memory "0"
        check_dockerd notequal config CpuShares "0"
        check_dockerd notequal config CpuShares "1024"
        check_dockerd notequal config RestartPolicy.Name "always"
        check_dockerd equal config RestartPolicy.Name "on-failure"
        check_dockerd equal config MaximumRetryCount "5"
      fi
    fi
  fi
}
