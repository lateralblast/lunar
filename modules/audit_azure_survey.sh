# audit_azure_survey
#
# Audit Azure survey setting
#
# This requires the Azure CLI to be installed and configured
#
# Refer to https://learn.microsoft.com/en-au/cli/azure/command-line-tools-survey-guidance?view=azure-cli-latest
#.

audit_azure_survey () {
  survey_check=$( az config get core.survey_message --query value -o tsv 2> /dev/null )
  if [ "$survey_check" = "false" ]; then
    increment_secure   "Azure survey reminder is disabled"
  else
    increment_insecure "Azure survey reminder is enabled"
  fi
}
