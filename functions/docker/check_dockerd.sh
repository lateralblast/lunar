#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2009
# shellcheck disable=SC2016

# check_dockerd
#
# Check dockerd parameter value
#.

check_dockerd () {
  print_function "check_dockerd"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    if [ "${audit_mode}" != 2 ]; then
      used="${1}"
      type="${2}"
      param="${3}"
      value="${4}"
      if [ "${type}" = "config" ]; then
        if [ "${value}" ]; then
         verbose_message "Docker \"${type}\" parameter \"${param}\" has value \"${value}\"" "check"
        else
         verbose_message "Docker \"${type}\" parameter \"${param}\" has no value" "check"
        fi
      else
        if [ "${value}" ]; then
         verbose_message "Docker \"${type}\" parameter \"${param}\" is \"${used}\" and has value \"${value}\"" "check"
        else
         verbose_message "Docker \"${type}\" parameter \"${param}\" is \"${used}\"" "check"
        fi
      fi
      case "${type}" in
        "daemon")
          command="ps -ef | grep dockerd | grep \"${param}\""
          command_message "${command}"
          check=$( eval "${command}" )
          if [ "${check}" ] && [ "${value}" ] && [ "${used}" = "unused" ]; then
            command="ps -ef | grep dockerd | grep \"${param}\" | grep \"${value}\""
            command_message "${command}"
            check=$( eval "${command}" )
            if [ ! "${check}" ]; then
              increment_insecure "Docker parameter \"${param}\" is not set to \"${value}\""
            else
              increment_secure   "Docker parameter \"${param}\" is set to \"${value}\""
            fi
          else
            if [ "${used}" = "used" ] && [ ! "${check}" ]; then
              
              increment_insecure "Docker parameter \"${param}\" is not used"
            else
              
              increment_secure   "Docker parameter \"${param}\" is \"${used}\""
            fi
          fi
          ;;
        "info")
          command="docker info 2> /dev/null |grep \"${param}\""
          command_message "${command}"
          check=$( eval "${command}" )
          if [ "${check}" ] && [ "${value}" ] && [ "${used}" = "unused" ]; then
            command="docker info 2> /dev/null | grep \"${param}\" | grep \"${value}\""
            command_message "${command}"
            check=$( eval "${command}" )
            if [ ! "${check}" ]; then
              increment_insecure "Docker parameter \"${param}\" is not set to \"${value}\""
            else
              increment_secure   "Docker parameter \"${param}\" is set to \"${value}\""
            fi
          else
            increment_secure "Docker parameter \"${param}\" is \"${used}\""
          fi
          ;;
        "kernel")
          OFS=$IFS
          IFS=$(printf '\n+'); IFS=${IFS%?}
          command="docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: CapAdd={{ .HostConfig.CapAdd }}' 2> /dev/null"
          command_message "${command}"
          docker_info=$( eval "${command}" )
          if [ ! "${docker_info}" ]; then
            verbose_message "No Docker instances" notice
          fi
          for info in ${docker_info}; do
            command="echo \"${info}\" | cut -f1 -d:"
            command_message "${command}"
            docker_id=$( eval "${command}" )
            command="echo \"${info}\" | cut -f2 -d: | cut -f2 -d= | grep \"${param}\""
            command_message "${command}"
            check=$( eval "${command}" )
            if [ "${used}" = "used" ]; then
              if [ "${profile}" ]; then
                increment_secure   "Docker instance \"${docker_id}\" has capability \"${param}\""
              else
                increment_insecure "Docker instance \"${docker_id}\" does not have capability \"${param}\""
              fi
            else
              if [ "${profile}" ]; then
                increment_secure   "Docker instance \"${docker_id}\" does not have capability \"${param}\""
              else
                increment_insecure "Docker instance \"${docker_id}\" has capability \"${param}\""
              fi
              command="docker inspect --format '{{ .Id }}: CapAdd={{ .HostConfig.CapDrop }}' \"${docker_id}\" | cut -f2 -d= | grep \"${param}\""
              command_message "${command}"
              check=$( eval "${command}" )
              if [ "${check}" ]; then
                increment_secure   "Docker instance \"${docker_id}\" forcibly drops capability \"${param}\""
              else
                increment_insecure "Docker instance \"${docker_id}\" does not forcibly capability \"${param}\""
              fi
            fi
          done
          IFS=$OFS
          ;;
        "config")
          OFS=$IFS
          IFS=$(printf '\n+'); IFS=${IFS%?}
          case ${param} in
            "AppArmorProfile")
              command="docker ps --quiet --all | xargs docker inspect --format \"{{ .Id }}: ${param}={{ .${param} }}\" 2> /dev/null"
              command_message "${command}"
              docker_info=$( eval "${command}" )
              ;;
            "User")
              command="docker ps --quiet --all | xargs docker inspect --format \"{{ .Id }}: ${param}={{ .Config.${param} }}\" 2> /dev/null"
              command_message "${command}"
              docker_info=$( eval "${command}" )
              ;;
            "Ports")
              command="docker ps --quiet --all | xargs docker inspect --format \"{{ .Id }}: ${param}={{ .NetworkSettings.${param} }}\" 2> /dev/null"
              command_message "${command}"
              docker_info=$( eval "${command}" )
              ;;
            "Propagation")
              command="docker ps --quiet --all | xargs docker inspect --format '{{ .Id }}: Propagation={{range $mnt := .Mounts}} {{json $mnt.Propagation}} {{end}}' 2> /dev/null"
              command_message "${command}"
              docker_info=$( eval "${command}" )
              ;;
            "Health")
              command="docker ps --quiet | xargs docker inspect --format '{{ .Id }}: Health={{ .State.Health.Status }}' 2> /dev/null"
              command_message "${command}"
              docker_info=$( eval "${command}" )
              ;;
            *)
              command="docker ps --quiet --all | xargs docker inspect --format \"{{ .Id }}: ${param}={{ .HostConfig.${param} }}\" 2> /dev/null"
              command_message "${command}"
              docker_info=$( eval "${command}" )
              ;;
          esac
          if [ ! "${docker_info}" ]; then
            verbose_message "No Docker instances with \"${param}\" set" notice
          fi
          for info in ${docker_info}; do
            command="echo \"${info}\" | cut -f1 -d:"
            command_message "${command}"
            docker_id=$( eval "${command}" )
            case ${used} in
              "notequal")
                command="echo \"${info}\" | cut -f2 -d: | cut -f2 -d= | grep -v \"\\[\\]\""
                command_message "${command}"
                profile=$( eval "${command}" )
                if [ ! "${value}" ]; then
                  if [ "${profile}" ]; then
                    increment_secure   "Docker instance \"${docker_id}\" does not have parameter \"${param}\" set"
                  else
                    increment_insecure "Docker instance \"${docker_id}\" has parameter \"${param}\" set"
                  fi
                else
                  if [ ! "${profile}" = "${value}" ]; then
                    increment_secure   "Docker instance \"${docker_id}\" does not have parameter \"${param}\" set to \"${value}\""
                  else
                    increment_insecure "Docker instance \"${docker_id}\" has parameter \"${param}\" set to \"${value}\""
                  fi
                fi
                ;;
              "equal")
                command="echo \"${info}\" | cut -f2 -d: | cut -f2 -d= | grep -v \"\[\]\""
                command_message "${command}"
                profile=$( eval "${command}" )
                if [ ! "${value}" ]; then
                  if [ ! "${profile}" ]; then
                    increment_secure   "Docker instance \"${docker_id}\" does not have parameter \"${param}\" set"
                  else
                    increment_insecure "Docker instance \"${docker_id}\" has parameter \"${param}\" set"
                  fi
                else
                  if [ "${profile}" = "${value}" ]; then
                    increment_secure   "Docker instance \"${docker_id}\" does not have parameter \"${param}\" set to \"${value}\""
                  else
                    increment_insecure "Docker instance \"${docker_id}\" does not have parameter \"${param}\" set to \"${value}\""
                  fi
                fi
                ;;
              "notinclude")
                command="echo \"${info}\" | cut -f2 -d: | cut -f2 -d= | grep \"${param}\""
                command_message "${command}"
                profile=$( eval "${command}" )
                if [ ! "${profile}" ]; then
                  increment_secure   "Docker instance \"${docker_id}\" parameter \"${param}\" does not include \"${value}\""
                else
                  increment_insecure "Docker instance \"${docker_id}\" parameter \"${param}\" includes \"${value}\""
                fi
                ;; 
              "include")
                command="echo \"${info}\" | cut -f2 -d: | cut -f2 -d= | grep \"${param}\""
                command_message "${command}"
                profile=$( eval "${command}" )
                if [ "${profile}" ]; then
                  increment_secure   "Docker instance \"${docker_id}\" parameter \"${param}\" includes \"${value}\""
                else
                  increment_insecure "Docker instance \"${docker_id}\" parameter \"${param}\" does not include \"${value}\""
                fi
                ;; 
            esac 
          done
          IFS=$OFS
          ;;
      esac
    fi
  fi
}
