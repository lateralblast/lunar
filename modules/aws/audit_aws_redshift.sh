#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_redshift
#
# Check AWS Redshift
#
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/cluster-allow-version-upgrade.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-audit-logging-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-encrypted.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-encrypted-with-kms-customer-master-keys.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-in-vpc.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-parameter-groups-require-ssl.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-publicly-accessible.html
#.

audit_aws_redshift () {
  print_function  "audit_aws_redshift"
  verbose_message "Redshift"   "check"
  command="aws redshift describe-clusters --region \"${aws_region}\" --query 'Clusters[].ClusterIdentifier' --output text"
  command_message "${command}"
  dbs=$( eval "${command}" )
  for db in ${dbs}; do
    # Check if version upgrades are enabled
    command="aws redshift describe-clusters --region \"${aws_region}\" --cluster-identifier \"${db}\" --query 'Clusters[].AllowVersionUpgrade' | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure     "Redshift instance \"${db}\" has version upgrades enabled"
    else
      increment_insecure   "Redshift instance \"${db}\" does not have version upgrades enabled"
      verbose_message      "aws redshift modify-cluster --region \"${aws_region}\" --cluster-identifier \"${db}\" --allow-version-upgrade" "fix"
    fi
    # Check if audit logging is enabled
    command="aws redshift describe-logging-status --region \"${aws_region}\" --cluster-identifier \"${db}\" | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure     "Redshift instance \"${db}\" has logging enabled"
    else
      increment_insecure   "Redshift instance \"${db}\" does not have logging enabled"
      verbose_message      "aws redshift enable-logging --region \"${aws_region}\" --cluster-identifier \"${db}\" --bucket-name <aws-redshift-audit-logs>" "fix"
    fi
    # Check if encryption is enabled
    command="aws redshift describe-logging-status --region \"${aws_region}\" --cluster-identifier \"${db}\" --query 'Clusters[].Encrypted' | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure     "Redshift instance \"${db}\" has encryption enabled"
    else
      increment_insecure   "Redshift instance \"${db}\" does not have encryption enabled"
    fi
    # Check if KMS keys are being used
    command="aws redshift describe-logging-status --region \"${aws_region}\" --cluster-identifier \"${db}\" --query 'Clusters[].[Encrypted,KmsKeyId]' | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure     "Redshift instance \"${db}\" is using KMS keys"
    else
      increment_insecure   "Redshift instance \"${db}\" is not using KMS keys"
    fi
    # Check if EC2-VPC platform is being used rather than EC2-Classic
    command="aws redshift describe-logging-status --region \"${aws_region}\" --cluster-identifier \"${db}\" --query 'Clusters[].VpcId' --output text"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure     "Redshift instance \"${db}\" is using the EC2-VPC platform"
    else
      increment_insecure   "Redshift instance \"${db}\" may be using the EC2-Classic platform"
    fi
    # Check that parameter groups require SSL
    command="aws redshift describe-logging-status --region \"${aws_region}\" --cluster-identifier \"${db}\" --query 'Clusters[].ClusterParameterGroups[].ParameterGroupName[]' --output text"
    command_message "${command}"
    groups=$( eval "${command}" )
    for group in ${groups}; do
      command="aws redshift describe-cluster-parameters --region \"${aws_region}\" --parameter-group-name \"${group}\" --query 'Parameters[].Description' | grep -i ssl"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ -n "${check}" ]; then
        increment_secure   "Redshift instance \"${db}\" parameter group \"$group\" is using SSL"
      else
        increment_insecure "Redshift instance \"${db}\" parameter group \"$group\" is not using SSL"
      fi
    done
    # Check if Redshift is publicly available
    command="aws redshift describe-clusters --region \"${aws_region}\" --cluster-identifier \"${db}\" --query 'Clusters[].PubliclyAccessible' | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -z "${check}" ]; then
      increment_secure     "Redshift instance \"${db}\" is not publicly available"
    else
      increment_insecure   "Redshift instance \"${db}\" is publicly available"
    fi
  done
}
