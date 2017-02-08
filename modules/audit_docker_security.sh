# audit_docker_security
#
# Docker security
#
# Refer to Section(s) 5.1 Page(s) 126-7 CIS Docker Benchmark 1.13.0
# Refer to https://docs.docker.com/engine/security/apparmor/
# Refer to http://docs.docker.com/articles/security/#other-kernel-security-features
# Refer to https://github.com/docker/docker/blob/master/docs/security/apparmor.md
# Refer to http://docs.docker.com/reference/run/#security-configuration
#.

audit_docker_security () {
  if [ "$os_name" = "Linux" ]; then
    docker_bin=`which docker`
    if [ "$docker_bin" ]; then
      funct_verbose_message "Docker Security"
      if [ "$audit_mode" != 2 ]; then
        docker_info=`docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: User={{.Config.User }}' 2> /dev/null`
        for armor_info in $docker_info; do
          total=`expr $total + 1`
          docker_id=`echo "$armor_info" |cut -f1 -d:`
          profile=`echo "$armor_info" |cut -f2 -d: |cut -f2 -d=`
          if [ "$profile" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Docker instance $docker_id has and AppArmor profile [$secure Passes]"
          else
            insecure=`expr $insecure + 1`
            echo "Warning:   Docker instance $docker_id does not have an AppArmor profile [$insecure Warnings]"
          fi
        done
      fi
    fi
  fi
}
