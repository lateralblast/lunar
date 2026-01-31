#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_aws_environment
#
# Check AWS CLI etc is installed
#.

check_aws_environment () {
  aws_bin=$( command -v aws 2> /dev/null )
  if [ -f "$aws_bin" ]; then
    aws_creds="$HOME/.aws/credentials"
    if [ -f "${aws_creds}" ]; then
      if [ "${os_name}" = "Darwin" ]; then
        base64_d="base64 -D"
      else
        base64_d="base64 -d"
      fi
    else
      echo "AWS credentials file does not exit"
      exit
    fi
  else
    echo "AWS CLI is not installed"
    exit
  fi
  if [ ! "${aws_region}" ]; then
    aws_region=$( aws configure get region )
  fi
}

# check_azure_environment
#
# Check Azure CLI etc is installed
#.

check_azure_environment () {
  azure_bin=$( command -v az 2> /dev/null )
  if [ -f "$azure_bin" ]; then
    for cli_ext in databricks bastion resource-graph application-insights; do
      command="az extension list | grep \"${cli_ext}\""
      command_message "${command}" "exec"
      ext_test=$( eval "${command}" )
      if [ -z "${ext_test}" ]; then
        echo "Azure ${cli_ext} extension is not installed"
        exit
      fi
    done
  else
    echo "Azure CLI is not installed"
    exit
  fi
  command="az ad signed-in-user show --query displayName -o tsv"
  command_message "${command}" "exec"
  azure_display_name=$( eval "${command}" )
  if [ -z "${azure_display_name}" ]; then
    az login
  else
    verbose_message "Logged in as ${azure_display_name}" "notice"
  fi
}

# check_environment
#
# Do some environment checks
# Create base and temporary directory
#.

check_environment () {
  check_os_release
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message "" ""
    verbose_message "Checking if node is managed" "info"
    command="sudo pwpolicy -n -getglobalpolicy 2>&1 |cut -f1 -d:"
    command_message "${command}" "exec"
    managed_node=$( eval "${command}" )
    if [ "${managed_node}" = "Error" ]; then
      verbose_message "Node is not managed" "notice"
    else
      verbose_message "Node is managed" "notice"
    fi
    verbose_message "" ""
  fi
  # Load functions from functions directory
  if [ -d "${functions_dir}" ]; then
    if [ "${verbose_mode}" = "1" ]; then
      echo ""
      echo "Loading Functions"
      echo ""
    fi
    file_list=$( find "${functions_dir}" -name "*.sh" )
    for file_name in ${file_list}; do
      if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ] ||  [ "${os_vendor}" = "Debian" ] || [ "${os_vendor}" = "Ubuntu" ]; then
        . "${file_name}"
      else
        source "${file_name}"
      fi
      if [ "${verbose_mode}" = "1" ]; then
        verbose_message "\"${file_name}\"" "load"
      fi
    done
  fi
  # Load modules for modules directory
  if [ -d "${modules_dir}" ]; then
    if [ "${verbose_mode}" = "1" ]; then
      echo ""
      echo "Loading Modules"
      echo ""
    fi
    file_list=$( find "${modules_dir}" -name "*.sh" )
    for file_name in ${file_list}; do
      if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ] || [ "${os_vendor}" = "Debian" ] || [ "${os_vendor}" = "Ubuntu" ]; then
        . "${file_name}"
      else
        if [ "${file_name}" = "modules/audit_ftp_users.sh" ]; then
          if [ "${os_name}" != "VMkernel" ]; then
             source "${file_name}"
          fi
        else
          source "${file_name}"
        fi
      fi
      if [ "${verbose_mode}" = "1" ]; then
        verbose_message "\"${file_name}\"" "load"
      fi
    done
  fi
  # Private modules for customers
  if [ -d "${private_dir}" ]; then
      echo ""
      echo "Loading Customised Modules"
      echo ""
    if [ "${verbose_mode}" = "1" ]; then
      echo ""
    fi
    file_list=$( find "${private_dir}" -name "*.sh" )
    for file_name in ${file_list}; do
      if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ] ||  [ "${os_vendor}" = "Debian" ] || [ "${os_vendor}" = "Ubuntu" ]; then
        . "${file_name}"
      else
        source "${file_name}"
      fi
    done
    if [ "${verbose_mode}" = "1" ]; then
      echo "Loading:   ${file_name}"
    fi
  fi
  if [ ! -d "${base_dir}" ]; then
    mkdir -p "${base_dir}"
    chmod 700 "${base_dir}"
  fi
  if [ ! -d "${temp_dir}" ]; then
    mkdir -p "${temp_dir}"
  fi
  if [ "${audit_mode}" = 0 ]; then
    if [ ! -d "${work_dir}" ]; then
      mkdir -p "${work_dir}"
    fi
  fi
}
