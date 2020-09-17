# audit_aws_ec
#
# Refer to https://www.cloudconformity.com/conformity-rules/ElastiCache/elasticache-multi-az.html
#.

audit_aws_ec () {
  verbose_message "ElastiCache"
  caches=$( aws elasticache describe-replication-groups --region $aws_region --query 'ReplicationGroups[].ReplicationGroupId' --output text )
  for cache in $caches; do 
    check=$( aws elasticache describe-replication-groups --region $aws_region --replication-group-id $cache --query 'ReplicationGroups[].AutomaticFailover' | grep enabled )
    if [ "$check" ]; then
      increment_secure "ElastiCache $cache is Multi-AZ enabled"
    else
      increment_insecure "ElastiCache $cache is not Multi-AZ enabled"
      lockdown_command "aws elasticache modify-replication-group --region $aws_region --replication-group-id $cache --automatic-failover-enabled --apply-immediately"
    fi
  done
}

