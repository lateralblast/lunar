# audit_docker_security
#
# Docker security
#
# Refer to Section(s) 5.1 Page(s) 126-7 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/security/apparmor/
# Refer to http://docs.docker.com/articles/security/#other-kernel-security-features
# Refer to https://github.com/docker/docker/blob/master/docs/security/apparmor.md
# Refer to http://docs.docker.com/reference/run/#security-configuration
# Refer to Section(s) 5.2 Page(s) 128-9 CIS Docker Benchmark 1.13.0
# Refer to http://docs.docker.com/articles/security/#other-kernel-security-features
# Refer to http://docs.docker.com/reference/run/#security-configuration
# Refer to http://docs.fedoraproject.org/en-US/Fedora/13/html/Security-Enhanced_Linux/
# Refer to Section(s) 5.3 Page(s) 130-1 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/articles/security/#linux-kernel-capabilities
# Refer to https://github.com/docker/docker/blob/master/daemon/execdriver/native/template/default_template.go
# Refer to http://man7.org/linux/man-pages/man7/capabilities.7.html
# Refer to http://www.oreilly.com/webops-perf/free/files/docker-security.pdf
#.

audit_docker_security () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    docker_bin=`which docker`
    if [ "$docker_bin" ]; then
      funct_verbose_message "Docker Security"
      if [ "$audit_mode" != 2 ]; then
        OFS=$IFS
        IFS=$'\n'
        docker_info=`docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: AppArmorProfile={{ .AppArmorProfile }}' 2> /dev/null`
        for info in $docker_info; do
          total=`expr $total + 1`
          docker_id=`echo "$info" |cut -f1 -d:`
          profile=`echo "$info" |cut -f2 -d: |cut -f2 -d=`
          echo "Checking:  Docker instance $docker_id has an AppArmor profile"
          if [ "$profile" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Docker instance $docker_id has an AppArmor profile [$secure Passes]"
          else
            insecure=`expr $insecure + 1`
            echo "Warning:   Docker instance $docker_id does not have an AppArmor profile [$insecure Warnings]"
          fi
        done
        docker_info=`docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: SecurityOpt={{ .HostConfig.SecurityOpt }}' 2> /dev/null`
        for info in $docker_info; do
          total=`expr $total + 1`
          docker_id=`echo "$info" |cut -f1 -d:`
          profile=`echo "$info" |cut -f2 -d: |cut -f2 -d=`
          echo "Checking:  Docker instance $docker_id has an SELinux profile"
          if [ ! "$profile" = "<no value>" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Docker instance $docker_id has a SELinux profile [$secure Passes]"
          else
            insecure=`expr $insecure + 1`
            echo "Warning:   Docker instance $docker_id does not have a SELinux profile [$insecure Warnings]"
          fi
        done
      fi
      IFS=$OFS
      for param in NET_ADMIN SYS_ADMIN SYS_MODULE; do
        funct_dockerd_check unused kernel $param
      done
    fi
  fi
}
