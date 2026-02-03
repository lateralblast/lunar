#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_inspector
#
# Check AWS Inspector
#
# Refer to https://docs.aws.amazon.com/inspector/latest/userguide/inspector_introduction.html
#.

audit_aws_inspector () {
  # check for templates
  print_function  "audit_aws_inspector"
  verbose_message "Inspector"   "check"
  command="aws inspector list-assessment-templates 2> /dev/null --output text"
  command_message "${command}"
  templates=$( eval "${command}" )
  if [ -n "${templates}" ]; then
    # check for subscriptions to templates
    command="aws inspector list-event-subscriptions --region \"${aws_region}\" --query subscriptions --output text"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ "${check}" ]; then
      increment_secure   "Inspectors have subscriptions"
    else
      increment_insecure "Inspectors do not have subscriptions"
    fi
    for template in ${templates}; do
      command="aws inspector describe-assessment-templates --region \"${aws_region}\" --assessment-template-arns \"${template}\" --query 'assessmentTemplates[].name' --output text"
      command_message "${command}"
      names=$( eval "${command}" )
      for name in ${ansible_value}s; do
        command="aws ec2 describe-instances --region \"${aws_region}\" --query 'Reservations[].Instances[].InstanceId' --output text"
        command_message "${command}"
        instances=$( eval "${command}" )
        for instance in ${instances}; do
          command="aws ec2 describe-instances --region \"${aws_region}\" --instance-id \"${instance}\" --query 'Reservations[].Instances[].Tags' | grep \"${ansible_value}\""
          command_message "${command}"
          check=$( eval "${command}" )
          if [ -n "${check}" ]; then
            increment_secure   "Instance \"${instance}\" has an inspector tag"
          else
            increment_insecure "Instance \"${instance}\" does not have an inspector tag"
          fi
        done
      done
    done
  else
    increment_insecure "No inspector templates exist"
  fi
}

