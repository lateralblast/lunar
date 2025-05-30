#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_docker_users
#
# Check users in docker group have recently logged in, if not lock them
# Warn of any users in group with UID greate than 100 and lock
#
# Refer to Section(s) 1.4 Page(s) 16-7  CIS Docker Benchmark 1.13.0
# Refer to Section(s) 4.1 Page(s) 105-6 CIS Docker Benchmark 1.13.0
#
# Refer to https://github.com/docker/docker/issues/2918
# Refer to https://github.com/docker/docker/pull/4572
# Refer to https://github.com/docker/docker/issues/7906
# Refer to https://www.altiscale.com/hadoop-blog/making-docker-work-yarn/
# Refer to https://docs.docker.com/articles/security/
# Refer to https://docs.docker.com/articles/security/#docker-daemon-attack-surface
# Refer to https://www.andreas-jung.com/contents/on-docker-security-docker-group-considered-harmful
# Refer to https://www.projectatomic.io/blog/2015/08/why-we-dont-let-non-root-users-run-docker-in-centos-fedora-or-rhel/
#.

audit_docker_users () {
  print_function "audit_docker_users"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    docker_bin=$( command -v docker )
    if [ "${docker_bin}" ]; then
      verbose_message "Docker Users" "check"
      check_file="/etc/group"
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( grep "^${docker_group}:" "${check_file}" | cut -f4 -d: | sed 's/,/ /g' )
        for user_name in ${user_list}; do
          last_login=$( last -1 "${user_name}" | grep '[a-z]' | awk '{print $1}' )
          if [ "${last_login}" = "wtmp" ]; then
            if test -r "/etc/shadow"; then
              lock_test=$( grep "^${user_name}:" /etc/shadow | grep -v 'LK' | cut -f1 -d: )
              if [ "${lock_test}" = "${user_name}" ]; then
                if [ "${audit_mode}" = 1 ]; then
                  increment_insecure "User \"${user_name}\" in group \"${docker_group}\" and has not logged in recently and their account is not locked"
                fi
                if [ "${audit_mode}" = 0 ]; then
                  backup_file     "${check_file}"
                  verbose_message "User \"${user_name}\" to locked" "set"
                  passwd -l "${user_name}"
                fi
              else
                increment_secure "User \"${user_name}\" in group \"${docker_group}\" has not logged in recently and their account is locked"
              fi
            fi
          fi
        done
      else
        restore_file "${check_file}" "${restore_dir}"
      fi
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( grep "^${docker_group}:" "${check_file}" | cut -f4 -d: | sed 's/,/ /g' )
        for user_name in ${user_list}; do
          user_id=$( uid -u "${user_name}" )
          if [ "${user_id}" -gt "${max_super_user_id}" ] ; then
            if test -r "/etc/shadow"; then
              lock_test=$( grep "^${user_name}:" /etc/shadow | grep -v 'LK' | cut -f1 -d: )
              if [ "${lock_test}" = "${user_name}" ]; then
                if [ "${audit_mode}" = 1 ]; then
                  increment_insecure  "User \"${user_name}\" is in group \"${docker_group}\" has and ID greater than \"${max_super_user_id}\" and their account is not locked"
                fi
                if [ "${audit_mode}" = 0 ]; then
                  backup_file         "${check_file}"
                  verbose_message     "User \"${user_name}\" to locked" "set"
                  passwd -l "${user_name}"
                fi
              else
                increment_secure  "User \"${user_name}\" in group \"${docker_group}\" has an id less than \"${max_super_user_id}\" and their account is locked"
              fi
            fi
          fi
        done
      else
        restore_file "${check_file}" "${restore_dir}"
      fi
      if [ "${audit_mode}" != 2 ]; then
        check_dockerd "notequal" "config" "User" ""
      fi
    fi
  fi
}
