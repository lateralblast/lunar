# audit_aws_rds
#
# Ensure that your RDS database instances have the Auto Minor Version Upgrade
# flag enabled in order to receive automatically minor engine upgrades during
# the specified maintenance window. Each version upgrade is available only after
# is tested and approved by AWS.
#
# AWS RDS will occasionally deprecate minor engine versions and provide new ones
# for upgrade. When the last version number within the release is replaced (e.g.
# 5.6.26 to 5.6.27), the version changed is considered minor. With Auto Minor
# Version Upgrade feature enabled, the version upgrades will occur automatically
# during the specified maintenance window so your RDS instances can get the new
# features, bug fixes and security patches for their database engines.
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-auto-minor-version-upgrade.html
#
# Ensure that your RDS database instances have automated backups enabled for
# point-in-time recovery. To back up your database instances, AWS RDS take
# automatically a full daily snapshot of your data (with transactions logs)
# during the specified backup window and keeps the backups for a limited period
# of time (known as retention period) defined by the instance owner.
#
# Creating point-in-time RDS instance snapshots periodically will allow you to
# handle efficiently your data restoration process in the event of a user error
# on the source database or to save data before making a major change to the
# instance database such as changing the structure of a table.
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-automated-backups-enabled.html
#.

audit_aws_rds () {
  dbs=`aws rds describe-db-instances --region $aws_region --query 'DBInstances[].DBInstanceIdentifier' --output text`
  for db in $dbs; do
    # Check if auto minor version upgrades are enabled
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query --query 'DBInstances[].AutoMinorVersionUpgrade' |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Database $db has auto minor version upgrades enabled [$secure Passes]" 
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Database $db does not have auto minor upgrades enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws rds modify-db-instance --region $aws_region --db-instance-identifier $db --auto-minor-version-upgrade --apply-immediately" fix
      funct_verbose_message "" fix
    fi
    # Check if automated backups are enabled
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query --query 'DBInstances[].BackupRetentionPeriod' --output text`
    if [ ! "$check" -eq "0" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Database $db has automated backups enabled [$secure Passes]" 
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Database $db does not have automated backups enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws rds modify-db-instance --region $aws_region --db-instance-identifier $db --backup-retention-period 7 --apply-immediately" fix
      funct_verbose_message "" fix
    fi
  done
}

