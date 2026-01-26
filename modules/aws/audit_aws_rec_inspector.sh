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
  templates=$( aws inspector list-assessment-templates 2> /dev/null --output text )
  if [ -n "${templates}" ]; then
    # Check for CVEs in assessments
    assessments=$( aws inspector list-assessment-runs --region "${aws_region}" --output text )
    if [ "${assessments}" ]; then
      token=$( aws inspector list-findings --query nextToken --output text | grep -v None )
      findings=$( aws inspector list-findings --query findingArns --output text | grep -v None )
      for finding in ${findings}; do
        instance=$( aws inspector describe-findings --finding-arns "${finding}" --query findings[].attributes[?key==\\\`INSTANCE_ID\\\`].value --output text )
        cve_id=$( aws inspector describe-findings --finding-arns "${finding}" --query findings[].attributes[?key==\\\`CVE_ID\\\`].value --output text )
        if [ "${cve_id}" ]; then
          increment_insecure "Instance \"${instance}\" is vulnerable to \"${cve_id}\""
        fi
      done
      if [ -n "${token}" ]; then
        while [ "${token}" ] ; do
          findings=$( aws inspector list-findings --next-token "${token}" --query findingArns --output text |grep -v None )
          for finding in ${findings}; do
            instance=$( aws inspector describe-findings --finding-arns "${finding}" --query findings[].attributes[?key==\\\`INSTANCE_ID\\\`].value --output text )
            cve_id=$( aws inspector describe-findings --finding-arns "${finding}" --query findings[].attributes[?key==\\\`CVE_ID\\\`].value --output text )
            if [ "${cve_id}" ]; then
              increment_insecure "Instance \"${instance}\" is vulnerable to \"${cve_id}\""
            fi
          done
          token=$( aws inspector list-findings --next-token "${token}" --query nextToken --output text |grep -v None )
        done
      fi
    fi
  else
    increment_insecure "No inspector templates exist"
  fi
}
