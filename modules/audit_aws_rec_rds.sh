# audit_aws_rec_rds
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-multi-az.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/general-purpose-ssd-storage-type.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/reserved-instance-expiration.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-sufficient-backup-retention-period.html
#.

audit_aws_rec_rds () {
  dbs=`aws rds describe-db-instances --region $aws_region --query 'DBInstances[].DBInstanceIdentifier' --output text`
  for db in $dbs; do
    # Check if database is Multi-AZ
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query --query 'DBInstances[].MultiAZ' |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    RDS instance $db is Multi-AZ enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db is not Multi-AZ enabled [$insecure Warnings]"
      verbose_message "" fix
      verbose_message "aws rds modify-db-instance --region $aws_region --db-instance-identifier $db --multi-az --apply-immediately" fix
      verbose_message "" fix
    fi
    # Check that EC2 volumes are using cost effective storage
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].StorageType' |grep "gp2"`
    if [ "$check" = "available" ]; then
      secure=`expr $secure + 1`
      echo "Pass:      RDS instance $db is using General Purpose SSD [$secure Passes] [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db is not using General Purpose SSD [$secure Passes] [$insecure Warnings]"
    fi
    # Check backup retention period is at least 7 days
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].BackupRetentionPeriod' --output text`
    if [ ! "$check" -lt "$aws_rds_min_retention" ]; then
      secure=`expr $secure + 1`
      echo "Pass:      RDS instance $db has a retention period greater than $aws_rds_min_retention [$secure Passes] [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db has a retention period less than $aws_rds_min_retention [$secure Passes] [$insecure Warnings]"
    fi
  done
  # Ensure that your AWS RDS Reserved Instances (RIs) are renewed before expiration
  dbs=`aws rds describe-reserved-db-instances --region $aws_region --query 'ReservedDBInstances[].ReservedDBInstanceId' --output text`
  for db in $dbs; do
    start_date=`aws rds describe-reserved-db-instances --region $aws_region --reserved-db-instance-id $db --query 'ReservedDBInstances[].StartTime' --output text |cut -f1 -d.`
    dur_secs=`aws rds describe-reserved-db-instances --region $aws_region --reserved-db-instance-id $db --query 'ReservedDBInstances[].Duration' --output text`
    curr_secs=`date "+%s"`
    start_secs=`date -j -f "%Y-%m-%dT%H:%M:%SS" "$start_date" "+%s"`
    exp_secs=`echo "($start_secs + $dur_secs)" |bc`
    test_secs=`echo "(7 * 84600)" |bc`
    left_secs=`echo "($exp_sec - $curr_secs)" |bc`
    if [ "$left_secs" -lt "$test_secs" ]; then
      secure=`expr $secure + 1`
      echo "Pass:      Reserved RDS instance $db has more than 7 days remaining [$secure Passes] [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Reserved RDS instance $db has less than 7 days remaining [$secure Passes] [$insecure Warnings]"
    fi
  done
}
