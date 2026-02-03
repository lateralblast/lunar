#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_rec_inspector
#
# Check Inspector Recommendations
#
# Refer to https://docs.aws.amazon.com/inspector/latest/userguide/inspector_introduction.html
#.

audit_aws_rec_inspector () {
  print_function  "audit_aws_rec_inspector"
  verbose_message "Inspector Recommendations" "check"
  # check for templates
  command="aws inspector list-assessment-templates 2> /dev/null --output text"
  command_message "${command}"
  templates=$( eval "${command}" )
  if [ -n "${templates}" ]; then
    # Check for CVEs in assessments
    command="aws inspector list-assessment-runs --region \"${aws_region}\" --output text"
    command_message "${command}"
    assessments=$( eval "${command}" )
    if [ "${assessments}" ]; then
      command="aws inspector list-findings --query nextToken --output text | grep -v None"
      command_message "${command}"
      token=$( eval "${command}" )
      command="aws inspector list-findings --query findingArns --output text | grep -v None"
      command_message "${command}"
      findings=$( eval "${command}" )
      for finding in ${findings}; do
        command="aws inspector describe-findings --finding-arns \"${finding}\" --query findings[].attributes[?key==\\\`INSTANCE_ID\\\`].value --output text"
        command_message "${command}"
        instance=$( eval "${command}" )
        command="aws inspector describe-findings --finding-arns \"${finding}\" --query findings[].attributes[?key==\\\`CVE_ID\\\`].value --output text"
        command_message "${command}"
        cve_id=$( eval "${command}" )
        if [ "${cve_id}" ]; then
          increment_insecure "Instance \"${instance}\" is vulnerable to \"${cve_id}\""
        fi
      done
      if [ -n "${token}" ]; then
        while [ "${token}" ] ; do
          command="aws inspector list-findings --next-token \"${token}\" --query findingArns --output text |grep -v None"
          command_message "${command}"
          findings=$( eval "${command}" )
          for finding in ${findings}; do
            command="aws inspector describe-findings --finding-arns \"${finding}\" --query findings[].attributes[?key==\\\`INSTANCE_ID\\\`].value --output text"
            command_message "${command}"
            instance=$( eval "${command}" )
            command="aws inspector describe-findings --finding-arns \"${finding}\" --query findings[].attributes[?key==\\\`CVE_ID\\\`].value --output text"
            command_message "${command}"
            cve_id=$( eval "${command}" )
            if [ "${cve_id}" ]; then
              increment_insecure "Instance \"${instance}\" is vulnerable to \"${cve_id}\""
            fi
          done
          command="aws inspector list-findings --next-token \"${token}\" --query nextToken --output text |grep -v None"
          command_message "${command}"
          token=$( eval "${command}" )
        done
      fi
    fi
  else
    increment_insecure "No inspector templates exist"
  fi
}
