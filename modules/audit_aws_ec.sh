# audit_aws_ec
#
# Ensure that your ElastiCache Redis Cache clusters are using a Multi-AZ
# deployment configuration to enhance High Availability (HA) through
# automatic failover to a read replica in case of a primary cache node
# failure.
#
# Enabling the Multi-AZ Automatic Failover feature for your Redis Cache
# clusters will improve the fault tolerance in case the read/write primary
# node becomes unreachable due to loss of network connectivity, loss of
# availability in the primary’s AZ, etc.
#
# Refer to https://www.cloudconformity.com/conformity-rules/ElastiCache/elasticache-multi-az.html
#.

audit_aws_ec () {
  # Check Cloud Formation stacks are using SNS
  caches=`aws elasticache describe-replication-groups --region $aws_region --query 'ReplicationGroups[].ReplicationGroupId' --output text` 
  for cache in $caches; do 
    total=`expr $total + 1`
    check=`aws elasticache describe-replication-groups --region $aws_region --replication-group-id $cache --query 'ReplicationGroups[].AutomaticFailover' |grep enabled`
    stack=`echo "$stack" |cut -f2 -d/`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    ElastiCache $cache is Multi-AZ enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   ElastiCache $cache is not Multi-AZ enabled [$insecure Warnings]"
    fi
  done
}

