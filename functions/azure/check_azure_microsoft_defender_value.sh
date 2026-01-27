#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_microsoft_defender_value
#
# Check Azure Microsoft Defender Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_microsoft_defender_value () {
  description="$1"
  parameter_name="$2"
  correct_value="$3"
  print_function  "check_azure_microsoft_defender_value"
  verbose_message "Azure Microsoft Defender \"${description}\" parameter \"${parameter_name}\" is set to \"${correct_value}\"" "check"
  actual_value=$( az security pricing show --name "${parameter_name}" --query pricingTier -o tsv )
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "Microsoft Defender \"${parameter_name}\" is set to \"${correct_value}\""
  else
    increment_insecure "Microsoft Defender \"${parameter_name}\" is not set to \"${correct_value}\""
    if [ "${parameter_name}" = "CloudPosture" ]; then
      verbose_message    "az security pricing update --name \"${parameter_name}\" --tier \"${correct_value}\" --extensions name=ApiPosture isEnabled=true" "fix"
    else
      if [ "${parameter_name}" = "Api" ]; then
        verbose_message    "az security pricing update --name \"${parameter_name}\" --tier \"${correct_value}\" --subplan <subplan>" "fix"
      else
        verbose_message    "az security pricing update --name \"${parameter_name}\" --tier \"${correct_value}\"" "fix"
      fi
    fi
  fi
}
