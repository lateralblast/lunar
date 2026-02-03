#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_rec_rds
#
# Check RDS recommendations
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-multi-az.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/general-purpose-ssd-storage-type.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/reserved-instance-expiration.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-sufficient-backup-retention-period.html
#.

audit_aws_rec_rds () {
  print_function  "audit_aws_rec_rds"
  verbose_message "RDS Recommendations" "check"
  command="aws rds describe-db-instances --region \"${aws_region}\" --query 'DBInstances[].DBInstanceIdentifier' --output text"
  command_message "${command}"
  dbs=$( eval "${command}" )
  for db in ${dbs}; do
    # Check if database is Multi-AZ
    command="aws rds describe-db-instances --region \"${aws_region}\" --db-instance-identifier \"${db}\" --query 'DBInstances[].MultiAZ' | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ -n "${check}" ]; then
      increment_secure   "RDS instance \"${db}\" is Multi-AZ enabled"
    else
      increment_insecure "RDS instance \"${db}\" is not Multi-AZ enabled"
      verbose_message    "aws rds modify-db-instance --region ${aws_region} --db-instance-identifier ${db} --multi-az --apply-immediately" "fix"
    fi
    # Check that EC2 volumes are using cost effective storage
    command="aws rds describe-db-instances --region \"${aws_region}\" --db-instance-identifier \"${db}\" --query 'DBInstances[].StorageType' |grep \"gp2\""
    command_message "${command}"
    check=$( eval "${command}" )
    if [ "${check}" = "available" ]; then
      increment_secure   "RDS instance \"${db}\" is using General Purpose SSD"
    else
      increment_insecure "RDS instance \"${db}\" is not using General Purpose SSD"
    fi
    # Check backup retention period is at least 7 days
    command="aws rds describe-db-instances --region \"${aws_region}\" --db-instance-identifier \"${db}\" --query 'DBInstances[].BackupRetentionPeriod' --output text"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ ! "${check}" -lt "$aws_rds_min_retention" ]; then
      increment_secure   "RDS instance \"${db}\" has a retention period greater than \"$aws_rds_min_retention\""
    else
      increment_insecure "RDS instance \"${db}\" has a retention period less than \"$aws_rds_min_retention\""
    fi
  done
  # Ensure that your AWS RDS Reserved Instances (RIs) are renewed before expiration
  command="aws rds describe-reserved-db-instances --region \"${aws_region}\" --query 'ReservedDBInstances[].ReservedDBInstanceId' --output text"
  command_message "${command}"
  dbs=$( eval "${command}" )
  for db in ${dbs}; do
    command="aws rds describe-reserved-db-instances --region \"${aws_region}\" --reserved-db-instance-id \"${db}\" --query 'ReservedDBInstances[].StartTime' --output text |cut -f1 -d. "
    command_message "${command}"
    start_date=$( eval "${command}" )
    command="aws rds describe-reserved-db-instances --region \"${aws_region}\" --reserved-db-instance-id \"${db}\" --query 'ReservedDBInstances[].Duration' --output text"
    command_message "${command}"
    dur_secs=$( eval "${command}" )
    command="date \"+%s\""
    command_message "${command}"
    curr_secs=$( eval "${command}" )
    if [ "${os_name}" = "Linux" ]; then
      command="date -d \"${start_date}\" \"+%s\""
      command_message "${command}"
      start_secs=$( eval "${command}" )
    else
      command="date -j -f \"%Y-%m-%dT%H:%M:%SS\" \"${start_date}\" \"+%s\""
      command_message "${command}"
      start_secs=$( eval "${command}" )
    fi
    command="echo \"(${start_secs} + ${dur_secs})\" | bc"
    command_message "${command}"
    exp_secs=$( eval "${command}" )
    command="echo \"(7 * 84600)\" | bc"
    command_message "${command}"
    test_secs=$( eval "${command}" )
    command="echo \"(${exp_secs} - ${curr_secs})\" | bc"
    command_message "${command}"
    left_secs=$( eval "${command}" )
    if [ "${left_secs}" -lt "${test_secs}" ]; then
      increment_secure   "Reserved RDS instance \"${db}\" has more than 7 days remaining"
    else
      increment_insecure "Reserved RDS instance \"${db}\" has less than 7 days remaining"
    fi
  done
}
