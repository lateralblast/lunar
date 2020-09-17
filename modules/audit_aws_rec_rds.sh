# audit_aws_rec_rds
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-multi-az.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/general-purpose-ssd-storage-type.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/reserved-instance-expiration.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-sufficient-backup-retention-period.html
#.

audit_aws_rec_rds () {
  verbose_message "RDS Recommendations"
  dbs=$( aws rds describe-db-instances --region $aws_region --query 'DBInstances[].DBInstanceIdentifier' --output text )
  for db in $dbs; do
    # Check if database is Multi-AZ
    check=$( aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].MultiAZ' | grep true )
    if [ "$check" ]; then
      increment_secure "RDS instance $db is Multi-AZ enabled"
    else
      increment_insecure "RDS instance $db is not Multi-AZ enabled"
      verbose_message "" fix
      verbose_message "aws rds modify-db-instance --region $aws_region --db-instance-identifier $db --multi-az --apply-immediately" fix
      verbose_message "" fix
    fi
    # Check that EC2 volumes are using cost effective storage
    check=$( aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].StorageType' |grep "gp2" )
    if [ "$check" = "available" ]; then
      increment_secure "RDS instance $db is using General Purpose SSD"
    else
      increment_insecure "RDS instance $db is not using General Purpose SSD"
    fi
    # Check backup retention period is at least 7 days
    check=$( aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].BackupRetentionPeriod' --output text )
    if [ ! "$check" -lt "$aws_rds_min_retention" ]; then
      increment_secure "RDS instance $db has a retention period greater than $aws_rds_min_retention"
    else
      increment_insecure "RDS instance $db has a retention period less than $aws_rds_min_retention"
    fi
  done
  # Ensure that your AWS RDS Reserved Instances (RIs) are renewed before expiration
  dbs=$( aws rds describe-reserved-db-instances --region $aws_region --query 'ReservedDBInstances[].ReservedDBInstanceId' --output text )
  for db in $dbs; do
    start_date=$( aws rds describe-reserved-db-instances --region $aws_region --reserved-db-instance-id $db --query 'ReservedDBInstances[].StartTime' --output text |cut -f1 -d. )
    dur_secs=$( aws rds describe-reserved-db-instances --region $aws_region --reserved-db-instance-id $db --query 'ReservedDBInstances[].Duration' --output text )
    curr_secs=$( date "+%s" )
    if [ "$os_name" = "Linux" ]; then
      start_secs=$( date -d "$start_date" "+%s" )
    else
      start_secs=$( date -j -f "%Y-%m-%dT%H:%M:%SS" "$start_date" "+%s" )
    fi
    exp_secs=$( echo "($start_secs + $dur_secs)" | bc )
    test_secs=$( echo "(7 * 84600)" | bc )
    left_secs=$( echo "($exp_secs - $curr_secs)" | bc )
    if [ "$left_secs" -lt "$test_secs" ]; then
      increment_secure "Reserved RDS instance $db has more than 7 days remaining"
    else
      increment_insecure "Reserved RDS instance $db has less than 7 days remaining"
    fi
  done
}
