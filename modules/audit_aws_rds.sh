# audit_aws_rds
#
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-auto-minor-version-upgrade.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-automated-backups-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-encryption-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-publicly-accessible.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-encrypted-with-kms-customer-master-keys.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/instance-not-in-public-subnet.html
# Refer to https://www.cloudconformity.com/conformity-rules/RDS/rds-master-username.html
#.

audit_aws_rds () {
  dbs=`aws rds describe-db-instances --region $aws_region --query 'DBInstances[].DBInstanceIdentifier' --output text`
  for db in $dbs; do
    # Check if auto minor version upgrades are enabled
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].AutoMinorVersionUpgrade' |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    RDS instance $db has auto minor version upgrades enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db does not have auto minor version upgrades enabled [$insecure Warnings]"
      verbose_message "" fix
      verbose_message "aws rds modify-db-instance --region $aws_region --db-instance-identifier $db --auto-minor-version-upgrade --apply-immediately" fix
      verbose_message "" fix
    fi
    # Check if automated backups are enabled
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].BackupRetentionPeriod' --output text`
    if [ ! "$check" -eq "0" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    RDS instance $db has automated backups enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db does not have automated backups enabled [$insecure Warnings]"
      verbose_message "" fix
      verbose_message "aws rds modify-db-instance --region $aws_region --db-instance-identifier $db --backup-retention-period $aws_rds_min_retention --apply-immediately" fix
      verbose_message "" fix
    fi
    # Check if RDS instance is encrypted
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].StorageEncrypted' |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    RDS instance $db is encrypted [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db is not encrypted [$insecure Warnings]"
    fi
    # Check if KMS is being used
    total=`expr $total + 1`
    key_id=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].KmsKeyId' --output text |cut -f2 -d/`
    if [ "$key_id" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    RDS instance $db is encrypted with a KMS key [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db is encrypted with a KMS key [$insecure Warnings]"
    fi
    # Check if RDS instance is publicly accessible
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].PubliclyAccessible' |grep true`
    if [ ! "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    RDS instance $db is not publicly accessible [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db is publicly accessible [$insecure Warnings]"
    fi
    # Check if RDS instance VPC is publicly accessible
    total=`expr $total + 1`
    sgs=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[*].VpcSecurityGroups[].VpcSecurityGroupId' --output text`
    for sg in $sgs; do
      check_aws_open_port $sg 3306 tcp MySQL RDS $db
    done
    # Check RDS instance is not on a public subnet
    total=`expr $total + 1`
    subnets=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].DBSubnetGroup.Subnets[].SubnetIdentifier --output text'`
    for subnet in $subnets; do
      check=`aws ec2 describe-route-tables --region $aws_region --filters "Name=association.subnet-id,Values=$subnet" --query 'RouteTables[].Routes[].DestinationCidrBlock' |grep "0.0.0.0/0"`
      if [ ! "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    RDS instance $db is not on a public facing subnet [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   RDS instance $db is ion a public facing subnet [$insecure Warnings]"
      fi
    done
    # Check that your Amazon RDS production databases are not using 'awsuser' as master 
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'DBInstances[].MasterUsername' |grep "awsuser"`
    if [ ! "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    RDS instance $db is not using awsuser as master username [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   RDS instance $db is using awsuser as master username [$insecure Warnings]"
    fi
  done
}
