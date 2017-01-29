# audit_aws_redshift
#
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/cluster-allow-version-upgrade.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-audit-logging-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-encrypted.html
#.

audit_aws_redshift () {
  dbs=`aws redshift describe-clusters --region $aws_region --query 'Clusters[].ClusterIdentifier' --output text`
  for db in $dbs; do
    # Check if version upgrades are enabled
    total=`expr $total + 1`
    check=`aws redshift describe-clusters --region $aws_region --cluster-identifier $db --query 'Clusters[].AllowVersionUpgrade' |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Redshift instance $db has version upgrades enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Redshift instance $db does not have version upgrades enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws redshift modify-cluster --region $aws_region --cluster-identifier $db --allow-version-upgrade" fix
      funct_verbose_message "" fix
    fi
    # Check if audit logging is enabled
    total=`expr $total + 1`
    check=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Redshift instance $db has logging enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Redshift instance $db does not have logging enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws redshift enable-logging --region $aws_region --cluster-identifier $db --bucket-name <aws-redshift-audit-logs>" fix
      funct_verbose_message "" fix
    fi
    # Check if encryption is enabled
    total=`expr $total + 1`
    check=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db --query 'Clusters[].Encrypted' |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Redshift instance $db has encryption enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Redshift instance $db does not have encryption enabled [$insecure Warnings]"
    fi
  done
}
