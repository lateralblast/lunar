# audit_aws_rec_ec
#
# Ensure that your AWS ElastiCache Reserved Cache Nodes are renewed before
# expiration in order to get a significant discount (up to 70% when used in
# steady state) on the hourly charges. The renewal process consists of
# purchasing another ElastiCache Reserved Cache Node so that Amazon can keep
# charging you based on the chosen reservation term. The default threshold
# for the number of days before expiration when the conformity rule checkup
# is performed is 7 (seven).
#
# With Reserved Cache Nodes (RCNs) you can optimize your Amazon ElastiCache
# costs based on your expected usage. Since RCNs are not renewed automatically,
# purchasing another reserved ElastiCache nodes before expiration will guarantee
# their billing at a discounted hourly rate.
#
# Refer to https://www.cloudconformity.com/conformity-rules/ElastiCache/reserved-cache-nodes-expiration.html
#.

audit_aws_rec_ec () {
  # Ensure that your AWS ElastiCache Reserved Instances (RIs) are renewed before expiration
  caches=`aws elasticache describe-reserved-cache-nodes --region $aws_region --query 'ReservedCacheNodes[].ReservedCacheNodeId' --output text`
  for cache in $caches; do
    start_date=`aws elasticache describe-reserved-cache-nodes --region $aws_region --reserved-cache-node-id $cache --query 'ReservedDBInstances[].ReservedCacheNodes' --output text |cut -f1 -d.`
    dur_secs=`aws elasticache describe-reserved-cache-nodes --region $aws_region --reserved-cache-node-id $cache --query 'ReservedDBInstances[].Duration' --output text`
    curr_secs=`date "+%s"`
    start_secs=`date -j -f "%Y-%m-%dT%H:%M:%SS" "$start_date" "+%s"`
    exp_secs=`echo "($start_secs + $dur_secs)" |bc`
    test_secs=`echo "(7 * 84600)" |bc`
    left_secs=`echo "($exp_sec - $curr_secs)" |bc`
    if [ "$left_secs" -lt "$test_secs" ]; then
      secure=`expr $secure + 1`
      echo "Pass:      Reserved ElastiCache instance $cache has more than 7 days remaining [$secure Passes] [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Reserved ElastiCache instance $cache has less than 7 days remaining [$secure Passes] [$insecure Warnings]"
    fi
  done
}

