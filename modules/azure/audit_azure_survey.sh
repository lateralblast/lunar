#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_survey
#
# Audit Azure survey setting
#
# Refer to https://learn.microsoft.com/en-au/cli/azure/command-line-tools-survey-guidance?view=azure-cli-latest
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_survey () {
  print_function  "audit_azure_survey"
  check_message   "Azure survey setting"
  command="az config get core.survey_message --query value --output tsv 2> /dev/null"
  command_message "${command}"
  survey=$( eval  "${command}" )
  if [ "${survey}" = "false" ]; then
    increment_secure   "Azure survey reminder is disabled"
  else
    increment_insecure "Azure survey reminder is enabled"
    verbose_message    "az config set core.survey_message=false" "fix"
  fi
}
