# audit_aws_rec_rds
#
# Ensure that your RDS instances are using Multi-AZ deployment configurations
# for high availability and automatic failover support fully managed by AWS.
#
# When Multi-AZ is enabled, AWS automatically provision and maintain a
# synchronous database standby replica on a dedicated hardware in a different
# datacenter (known as Availability Zone). AWS RDS will automatically switch
# from the primary instance to the available standby replica in the event of a
# failure such as an Availability Zone outage, an internal hardware or network
# outage, a software failure or in case of planned interruptions such as
# software patching or changing the RDS instance type.
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-multi-az.html
#
# Ensure that your RDS instances are using General Purpose SSDs instead of
# Provisioned IOPS SSDs for cost-effective storage that fits a broad range of
# database workloads. Unless you are running mission-critical applications that
# require more than 10000 IOPS or 160 MiB/s of throughput per database
#
# Using General Purpose (GP) SSD database storage instead of Provisioned IOPS
# (PIOPS) SSD storage represents a good strategy to cut down on AWS RDS costs
# because for GP SSDs you only pay for the storage compared to PIOPS SSDs where
# you pay for both storage and IOPS. Converting existing PIOPS-based databases
# to GP is often possible by configuring larger storage which gives higher
# baseline performance of IOPS for a lower cost.
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/general-purpose-ssd-storage-type.html
#
# Ensure that your AWS RDS Reserved Instances (RIs) are renewed before
# expiration in order to get the appropriate discount (based on the commitment
# term) on the hourly charge for these instances. The renewal process consists
# of purchasing another RDS Reserved Instance so that Amazon can keep charging
# you based on the chosen reservation term. The default threshold for the number
# of days before expiration when the conformity rule checkup is performed is 7
# (seven).
#
# With Reserved Instances (RIs) you can optimize your Amazon RDS costs based on
# your expected usage. Since RDS RIs are not renewed automatically, purchasing
# another reserved database instances on time will guarantee that these
# instances will be also billed at a discounted hourly rate.
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/reserved-instance-expiration.html
#
# Ensure that your RDS database instances have set a minimum backup retention
# period in order to achieve the compliance requirements. 
# 
# Having a minimum retention period set for RDS database instances will enforce
# your backup strategy to follow the best practices as specified in the
# compliance regulations. Retaining point-in-time RDS snapshots for a longer
# period of time will allow you to handle more efficiently your data restoration
# process in the event of failure.
#
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
      funct_verbose_message "" fix
      funct_verbose_message "aws rds modify-db-instance --region $aws_region --db-instance-identifier $db --multi-az --apply-immediately" fix
      funct_verbose_message "" fix
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
    if [ ! "$check" -lt "$aws_rds_retention" ]; then
      secure=`expr $secure + 1`
      echo "Pass:      RDS instance $db has a retention period greater than $aws_rds_retention [$secure Passes] [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db has a retention period less than $aws_rds_retention [$secure Passes] [$insecure Warnings]"
    fi
  done
  # Ensure that your AWS RDS Reserved Instances (RIs) are renewed before expiration
  dbs=`aws rds describe-reserved-db-instances --region $aws_region --query 'ReservedDBInstances[].ReservedDBInstanceId' --output text`
  for db in $dbs; do
    start_date=`aws rds describe-reserved-db-instances --region $aws_region --reserved-db-instance-id $db --query 'ReservedDBInstances[].StartTime' --output text |cut -f1 -d.`
    dur_secs=`aws rds describe-reserved-db-instances --region $aws_region --reserved-db-instance-id $db --query 'ReservedDBInstances[].StartTime' --output text`
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
