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
  done
}
