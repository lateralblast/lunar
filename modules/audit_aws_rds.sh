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
#.

audit_aws_rds () {
  # determine if your AWS Simple Email Service (SES) identities (domains and email addresses) are configured to use DKIM signatures
  dbs=`aws rds describe-db-instances --region $aws_region --query 'DBInstances[].DBInstanceIdentifier' --output text`
  for db in $dbs; do
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
  done
}

