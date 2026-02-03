#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_docker_daemon
#
# Check that Docker daemon activities are audited
#
# Refer to Section(s) 1.5-13  Page(s) 18-35   CIS Docker Benchmark 1.13.0
# Refer to Section(s) 2.4-13  Page(s) 41-58   CIS Docker Benchmark 1.13.0
# Refer to Section(s) 2.14    Page(s) 60-1    CIS Docker Benchmark 1.13.0
# Refer to Section(s) 2.18    Page(s) 67-8    CIS Docker Benchmark 1.13.0
# Refer to Section(s) 2.20-3  Page(s) 70-5    CIS Docker Benchmark 1.13.0
# Refer to Section(s) 3.1-20  Page(s) 77-104  CIS Docker Benchmark 1.13.0
# Refer to Section(s) 5.10-1  Page(s) 142-5   CIS Docker Benchmark 1.13.0
# Refer to Section(s) 5.14    Page(s) 150-1   CIS Docker Benchmark 1.13.0
#
# Refer to https://containerd.tools/
# Refer to https://windsock.io/the-docker-proxy/
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html
# Refer to https://man7.org/linux/man-pages/man7/user_namespaces.7.html
# Refer to https://github.com/twistlock/authz
# Refer to https://github.com/docker/docker-registry/issues/612
# Refer to https://github.com/docker/docker/issues/8093
# Refer to https://github.com/docker/docker/issues/9015
# Refer to https://github.com/docker/docker/issues/14856
# Refer to https://github.com/docker/docker/issues/21050
# Refer to https://github.com/docker/docker/issues/22741
# Refer to https://github.com/docker/docker/issues/26713
# Refer to https://github.com/docker/docker/pull/20662
# Refer to https://github.com/docker/docker/pull/23213
# Refer to https://github.com/docker/docker/pull/26276
# Refer to https://github.com/docker/docker/pull/27223
# Refer to https://github.com/opencontainers/runc
# Refer to https://github.com/YungSang/fedora-atomic-packer/blob/master/oem/docker.socket
# Refer to https://github.com/mstanleyjones/docker.github.io/blob/af7dfdba8504f9b102fb31a78cd08a06c33a8975/engine/swarm/swarm_manager_locking.md
# Refer to https://docs.docker.com/registry/insecure/
# Refer to https://docs.docker.com/articles/https/
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#daemon-configuration-file
# Refer to https://docs.docker.com/reference/commandline/cli/#daemon-storage-driver-option
# Refer to https://docs.docker.com/engine/userguide/storagedriver/
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#default-ulimits
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#storage-driver-options
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#access- authorization
# Refer to https://docs.docker.com/engine/extend/authorization/
# Refer to https://docs.docker.com/registry/spec/api/
# Refer to https://docs.docker.com/engine/userguide/networking/default_network/binding/
# Refer to https://docs.docker.com/engine/admin/systemd/
# Refer to https://docs.docker.com/articles/basics/#bind-docker-to-another-hostport-or-a-unix-socket
# Refer to https://docs.docker.com/articles/certificates/
# Refer to https://docs.docker.com/reference/commandline/cli/#insecure-registries
# Refer to https://docs.docker.com/reference/commandline/cli/#daemon-socket-option
# Refer to https://docs.docker.com/articles/basics/#bind-docker-to-another-hostport-or-a-unix-socket
# Refer to https://docs.docker.com/engine/reference/commandline/daemon/#daemon-configuration-file
# Refer to https://docs.docker.com/engine/admin/configuring/
# Refer to https://docs.docker.com/articles/runmetrics/
# Refer to https://docs.docker.com/reference/commandline/cli/#run
# Refer to https://docs.docker.com/reference/commandline/cli/#restart-policies
# Refer to https://www.slideshare.net/Docker/docker-registry-v2
# Refer to https://goldmann.pl/blog/2014/09/11/resource-management-in-docker/
# Refer to https://goldmann.pl/blog/2014/09/11/resource-management-in-docker/
# Refer to https://muehe.org/posts/switching-docker-from-aufs-to-devicemapper/
# Refer to https://daviddaeschler.com/2014/12/14/centos-7rhel-7-and-docker-containers-on-boot/
# Refer to https://blog.docker.com/2015/07/new-tool-v1-registry-docker-trusted-registry-v2-open-source/
# Refer to https://events.linuxfoundation.org/sites/events/files/slides/User%20Namespaces%20-%20ContainerCon%202015%20-%2016-9-final_0.pdf
# Refer to https://daviddaeschler.com/2014/12/14/centos-7rhel-7-and-docker-containers-on-boot/
# Refer to https://jpetazzo.github.io/assets/2015-03-05-deep-dive-into-docker-storage-drivers.html#1
# Refer to https://the.binbashtheory.com/creating-private-docker-registry-2-0-with-token-authentication-service/
#.

audit_docker_daemon () {
  print_function "audit_docker_daemon"
  string="Docker Daemon"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    docker_bin=$( command -v docker )
    if [ "${docker_bin}" ]; then
      check_file="/etc/audit/audit.rules"
      for docker_file in /usr/bin/docker /var/lib/docker /etc/docker /etc/default/docker /etc/docker/daemon.json /usr/bin/docker-containerd /usr/bin/docker-runc; do
        check_auditctl    "${docker_file}" "docker_file"
        check_append_file "${check_file}"  "-w ${docker_file} -k docker" "hash"
      done
      systemctl_check=$( command -v systemctl )
      if [ "${systemctl_check}" ]; then
        for docker_service in docker.service docker.socket; do
          check_auditctl "${docker_service}" "docker_service"
          docker_file=$( systemctl show -p FragmentPath ${docker_service} 2> /dev/null )
          check_append_file "${check_file}" "-w ${docker_file} -k docker" "hash"
          check_file_perms  "${check_file}" "0640" "root" "root"
        done
      fi
      for check_file in /etc/docker /etc/docker/certs.d; do
        check_file_perms ${check_file} 0750 root root
      done
      if [ -e "/etc/docker/certs.d" ]; then
        file_list=$( find /etc/docker/certs.d/ -type f )
        for check_file in ${file_list}; do
          check_file_perms "${check_file}" "440" "root" "root"
        done
      fi
      check_file_perms /var/run/docker.sock 660 root docker
      for check_file in /etc/default/docker /etc/docker/daemon.json; do
        check_file_perms "${check_file}" "640" "root" "root"
      done
      tlscert_file=""
      tlscacert_file=""
      tlskey_file=""
      for check_file in ${tlscert_file} ${tlscacert_file} ${tlskey_file}; do
        check_file_perms "${check_file}" "400" "root" "root"
      done
      check_dockerd     "unused"      "daemon" "insecure-registry"        ""
      check_dockerd     "unused"      "daemon" "storage-driver"           "aufs"
      check_dockerd     "unused"      "daemon" "net host"                 ""
      check_dockerd     "unused"      "info"   "Storage Driver"           "aufs"
      check_dockerd     "used"        "daemon" "tlsverify"                ""
      check_dockerd     "used"        "daemon" "tlscacert"                ""
      check_dockerd     "used"        "daemon" "tlscert"                  ""
      check_dockerd     "used"        "daemon" "tlskey"                   ""
      check_dockerd     "used"        "daemon" "default-ulimit"           ""
      check_dockerd     "used"        "daemon" "cgroup-parent"            ""
      check_dockerd     "used"        "daemon" "userns-remap"             ""
      check_file_exists "/etc/subuid" "yes"
      check_file_exists "/etc/subgid" "yes"
      check_dockerd     "unused"      "daemon" "storage-opt"
      check_dockerd     "used"        "daemon" "authorization-plugin"     ""
      check_dockerd     "used"        "daemon" "disable-legacy-registry"  ""
      check_dockerd     "used"        "daemon" "live-restore"             ""
      check_dockerd     "used"        "daemon" "userland-proxy"           "false"
      check_dockerd     "used"        "daemon" "seccomp-profile"          ""
      check_dockerd     "unused"      "daemon" "experimental"             ""
      if [ "${audit_mode}" != 2 ]; then
        check=$( docker swarm unlock-key 2> /dev/null )
        if [ "${check}" = "no unlock key is set" ]; then
          increment_insecure "Docker swarm unlock is not set"
        else
          increment_secure   "Docker swarm unlock key is not set or swarm is not running"
        fi
        check_dockerd   "notequal"    "config" "Memory"                   "0"
        check_dockerd   "notequal"    "config" "CpuShares"                "0"
        check_dockerd   "notequal"    "config" "CpuShares"                "1024"
        check_dockerd   "notequal"    "config" "RestartPolicy.Name"       "always"
        check_dockerd   "equal"       "config" "RestartPolicy.Name"       "on-failure"
        check_dockerd   "equal"       "config" "MaximumRetryCount"        "5"
      fi
    fi
  else
    na_message "${string}"
  fi
}
