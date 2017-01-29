# audit_aws_redshift
#
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/cluster-allow-version-upgrade.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-audit-logging-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-encrypted.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-encrypted-with-kms-customer-master-keys.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-in-vpc.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-parameter-groups-require-ssl.html
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
    # Check if KMS keys are being used
    total=`expr $total + 1`
    check=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db --query 'Clusters[].[Encrypted,KmsKeyId]' |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Redshift instance $db is using KMS keys [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Redshift instance $db is not using KMS keys [$insecure Warnings]"
    fi
    # Check if EC2-VPC platform is being used rather than EC2-Classic
    total=`expr $total + 1`
    check=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db --query 'Clusters[].VpcId' --output text`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Redshift instance $db is using the EC2-VPC platform [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Redshift instance $db may be using the EC2-Classic platform [$insecure Warnings]"
    fi
    # Check that parameter groups require SSL
    groups=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db --query 'Clusters[].ClusterParameterGroups[].ParameterGroupName[]' --output text`
    for group in $groups; do
      total=`expr $total + 1`
      check=`aws redshift describe-cluster-parameters --region $aws_region --parameter-group-name $group --query 'Parameters[].Description' |grep -i ssl`
      if [ "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    Redshift instance $db parameter group $group is using SSL [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   Redshift instance $db parameter group $group is not using SSL [$insecure Warnings]"
      fi
    done
  done
}
