# audit_azure_extensions
#
# Audit Azure extensions setting
#
# Make sure extenstions are not set to auto install and are not set to preview versions
#
# Refer to https://learn.microsoft.com/en-us/cli/azure/azure-cli-extensions-overview?view=azure-cli-latest
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_extensions () {
  print_function  "audit_azure_extensions"
  verbose_message "Azure extensions settings" "check"
  for parameter_name in "extension.use_dynamic_install" "extension.run_after_dynamic_install" "extension.dynamic_install_allow_preview"; do
    if [ "${parameter_name}" = "extension.dynamic_install_allow_preview" ]; then
      correct_value="false"
    else
      correct_value="no"
    fi
    verbose_message "Azure extensions parameter \"${parameter_name}\" is set to \"${correct_value}\"" "check"
    actual_value=$( az config get "${parameter_name}" --query value --output tsv 2> /dev/null )
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Azure extensions parameter \"${parameter_name}\" is set to \"${correct_value}\""
    else
      increment_insecure "Azure extensions parameter \"${parameter_name}\" is not set to \"${correct_value}\""
      verbose_message    "az config set ${parameter_name}=${correct_value}" "fix"
    fi
  done
}
