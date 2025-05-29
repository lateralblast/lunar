#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# print_version
#
# Print version information
#.

print_version () {
  echo "${script_version}"
}

# print_info
#
# Routing to parse script to print information like switch usage
#.

print_info () {
  info="$1"
  echo ""
  echo "Usage: $0 -${info}|--${info}"
  echo ""
  echo "${info}(s):"
  echo "---------"
  while read -r line; do
    test=$( echo "${line}" | grep "# ${info}" )
    if [ "${test}" ]; then
      switch=$( echo "$line" |cut -f1 -d# )
      desc=$( echo "$line" |cut -f2 -d# |sed "s/ ${info} - //g")
      echo "${switch}"
      echo "  ${desc}"
    fi
  done < "$0"
  echo ""
}

# print_help
#
# If given a -h or no valid switch print usage information
#.

print_help () {
  print_info "switch"
}

# print_usage
#
# Print usage information
# If given -H print some examples
#.

print_usage () {
  echo ""
  echo "Examples:"
  echo ""
  echo "Run AWS CLI audit"
  echo ""
  echo "$0 -w"
  echo ""
  echo "Run Docker audit"
  echo ""
  echo "$0 -d"
  echo ""
  echo "Run in Audit Mode (for Operating Systems)"
  echo ""
  echo "$0 -a"
  echo ""
  echo "Run in Audit Mode and provide more information (for Operating Systems)"
  echo ""
  echo "$0 -a -v"
  echo ""
  echo "Display Previous Backups:"
  echo ""
  echo "$0 -b"
  echo "Previous Backups:"
  echo "21_12_2012_19_45_05  21_12_2012_20_35_54  21_12_2012_21_57_25"
  echo ""
  echo "Restore from Previous Backup:"
  echo ""
  echo "$0 -u 21_12_2012_19_45_05"
  echo ""
  echo "List tests:"
  echo ""
  echo "$0 -S"
  echo ""
  echo "Only run shell based tests:"
  echo ""
  echo "$0 -s audit_shell_services"
  echo ""
}

# print_backups
#
# Print backups
#.

print_backups () {
  echo ""
  echo "Previous backups:"
  echo ""
  if [ -d "${base_dir}" ]; then
    find "${base_dir}" -maxdepth 1 -name "[0-9]*" -type d
  fi
}

# print_tests
#
# Print Tests
#. 

print_tests () {
  test_string="$1"
  echo ""
  if [ "${test_string}" = "UNIX" ]; then
    grep_string="-v aws"
  else
    grep_string="${test_string}"
  fi
  echo "${test_string} Security Tests:"
  echo ""
  dir_list=$( ls "${modules_dir}" ) 
  for dir_entry in ${dir_list} ; do
    case ${test_string} in
      AWS|aws)
        module_name=$( echo "${dir_entry}" | grep -v "^full_" |grep "aws" |sed "s/\.sh//g" )
        ;;
      Docker|docker)
        module_name=$( echo "${dir_entry}" | grep -v "^full_" |grep "docker" |sed "s/\.sh//g" )
        ;;
      Kubernetes|kubernetes|k8s)
        module_name=$( echo "${dir_entry}" | grep -v "^full_" |grep "kubernetes" |sed "s/\.sh//g" )
        ;;
      All|all)
        module_name=$( echo "${dir_entry}" | grep -v "^full_" |sed "s/\.sh//g" )
        ;;
      *)
        module_name=$( echo "${dir_entry}" | grep -v "^full_" |grep "${test_string}" |sed "s/\.sh//g" )
        ;;
    esac
    if [ -n "${module_name}" ]; then
      if [ "${verbose}" = 1 ]; then
        print_audit_info "${module_name}"
      else
        echo "${module_name}"
      fi
    fi
  done
  echo ""
}

# print_function
#
# Print fuction name
#.

print_function() {
  funct_name="$1"
  if [ "${verbose}" = 1 ]; then
    echo "Function:   ${funct_name}"
  fi
}

# print_results
#
# Print Results
#.

# print_module
#
# Print module name
#.

print_module() {
  module_name="$1"
  echo "Module:     ${module_name}"
}

print_results () {
  echo ""
  if [ "${reboot}" = 1 ]; then
    reboot="Required"
  else
    reboot="Not Required"
  fi
  if [ ! "${audit_mode}" = 2 ]; then
    if [ "${no_cat}" = "1" ]; then
      echo "Tests:      ${total}"
      echo "Passes:     ${secure}"
      echo "Warnings:   ${insecure}"
    else
      echo " \    /\    Tests:      ${total}"
      echo "  )  ( ')   Passes:     ${secure}"
      echo " (  /  )    Warnings:   ${insecure}"
      echo "  \(__)|    Reboot:     ${reboot}"
    fi
  fi
  if [ "${audit_mode}" != 1 ]; then
    echo "Reboot:     ${reboot}"
  fi
  if [ "${audit_mode}" = 0 ]; then
    echo "Backup:     ${work_dir}"
    echo "Restore:    $0 -u ${date_suffix}"
  fi
  echo ""
}

# print_changes
#
# Do a diff between previous file (saved) and existing file
#.

print_changes () {
  if [ -f "${base_dir}" ]; then
    echo ""
    echo "Printing changes:"
    echo ""
    file_list=$( find "${base_dir}" -type f -print )
    for saved_file in ${file_list}; do
      check_file=$( echo "${saved_file}" | cut -f 5- -d"/" )
      top_dir=$( echo "${saved_file}" | cut -f 1-4 -d"/" )
      echo "Directory: \"${top_dir}\""
      log_test=$( echo "${check_file}" |grep "log$" )
      if [ -n "${log_test}" ]; then
        echo "Original system parameters:"
        sed "s/,/ /g" < "${saved_file}"
      else
        echo "Changes to \"/${check_file}\":"
        diff "${saved_file}" "/${check_file}"
      fi
    done
  else
    echo "No changes made recently"
  fi
}

# print_previous
#
# Print previous changes
#.

print_previous () {
  if [ -d "${base_dir}" ]; then
    echo ""
    echo "Printing previous settings:"
    echo ""
    if [ -d "${base_dir}" ]; then
      find "${base_dir}" -type f -print -exec cat -n {} \;
    fi
  fi
}

# handle_output
#
# Handle output
#.

handle_output () {
  text="$1"
  echo "$1"
}

# checking_message
#
# Checking message
#.

checking_message () {
  verbose_message "$1" "check"
}

# setting_message
#
# Setting message
#.

setting_message () {
  verbose_message "$1" "set"
}

# print_audit_info
#
# This function searches the script for the information associated
# with a function.
# It finds the line starting with # function_name
# then reads until it finds a #.
#.

print_audit_info () {
  module="$1"
  comment_text=0
  verbose=1
  dir_name=$( pwd )
  check=$( echo "${module}" | grep "audit" )
  if [ -z "${check}" ]; then
    module="audit_${module}" 
  fi
  file_name="${dir_name}/modules/${module}.sh"
  if [ -f "${file_name}" ] ; then
    verbose_message "# Module: ${module}"
    while read -r line ; do
      if [ "${line}" = "# ${module}" ]; then
        comment_text=1
      else
        if [ "${comment_text}" = 1 ]; then
          if [ "${line}" = "#." ]; then
            verbose_message ""
            comment_text=0
          fi
          if [ "${comment_text}" = 1 ]; then
            verbose_message "${line}"
          fi
        fi
      fi
    done < "${file_name}"
  fi
}
