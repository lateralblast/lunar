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
  verbose_message "Azure survey setting" "check"
  command="az config get core.survey_message --query value --output tsv 2> /dev/null"
  survey_check=$( eval "${command}" )
  command_message "${command}" "exec"
  if [ "$survey_check" = "false" ]; then
    increment_secure   "Azure survey reminder is disabled"
  else
    increment_insecure "Azure survey reminder is enabled"
    verbose_message    "az config set core.survey_message=false" "fix"
  fi
}
