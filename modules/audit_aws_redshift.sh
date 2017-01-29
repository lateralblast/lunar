# audit_aws_redshift
#
# https://www.cloudconformity.com/conformity-rules/Redshift/cluster-allow-version-upgrade.html
#.

audit_aws_redshift () {
  dbs=`aws redshift describe-clusters --region $aws_region --query 'Clusters[].ClusterIdentifier' --output text`
  for db in $dbs; do
    # Check if version upgrades are enabled
    total=`expr $total + 1`
    check=`aws rds describe-db-instances --region $aws_region --db-instance-identifier $db --query 'Clusters[].AllowVersionUpgrade' |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Redshift instance $db has auto minor version upgrades enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Redshift instance $db does not have auto minor upgrades enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws aws redshift modify-cluster --region $aws_region --cluster-identifier $db --allow-version-upgrade" fix
      funct_verbose_message "" fix
    fi
  done
}
