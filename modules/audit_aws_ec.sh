# audit_aws_ec
#
# Refer to https://www.cloudconformity.com/conformity-rules/ElastiCache/elasticache-multi-az.html
#.

audit_aws_ec () {
  # Check Cloud Formation stacks are using SNS
  caches=`aws elasticache describe-replication-groups --region $aws_region --query 'ReplicationGroups[].ReplicationGroupId' --output text` 
  for cache in $caches; do 
    total=`expr $total + 1`
    check=`aws elasticache describe-replication-groups --region $aws_region --replication-group-id $cache --query 'ReplicationGroups[].AutomaticFailover' |grep enabled`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    ElastiCache $cache is Multi-AZ enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   ElastiCache $cache is not Multi-AZ enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws elasticache modify-replication-group --region $aws_region --replication-group-id $cache --automatic-failover-enabled --apply-immediately" fix
      funct_verbose_message "" fix
    fi
  done
}

