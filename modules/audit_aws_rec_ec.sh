# audit_aws_rec_ec
#
# Refer to https://www.cloudconformity.com/conformity-rules/ElastiCache/reserved-cache-nodes-expiration.html
#.

audit_aws_rec_ec () {
  verbose_message "ElastiCache Recommendation"
  # Ensure that your AWS ElastiCache Reserved Instances (RIs) are renewed before expiration
  caches=$( aws elasticache describe-reserved-cache-nodes --region $aws_region --query 'ReservedCacheNodes[].ReservedCacheNodeId' --output text )
  for cache in $caches; do
    start_date=$( aws elasticache describe-reserved-cache-nodes --region $aws_region --reserved-cache-node-id $cache --query 'ReservedDBInstances[].ReservedCacheNodes' --output text | cut -f1 -d. )
    dur_secs=$( aws elasticache describe-reserved-cache-nodes --region $aws_region --reserved-cache-node-id $cache --query 'ReservedDBInstances[].Duration' --output text )
    curr_secs=$( date "+%s" )
    if [ "$os_name" = "Linux" ]; then
      start_secs=$( date -d "$start_date" "+%s" )
    else
      start_secs=$( date -j -f "%Y-%m-%dT%H:%M:%SS" "$start_date" "+%s" )
    fi
    exp_secs=$( echo "($start_secs + $dur_secs)" | bc )
    test_secs=$( echo "(7 * 84600)" |bc )
    left_secs=$( echo "($exp_sec - $curr_secs)" | bc )
    if [ "$left_secs" -lt "$test_secs" ]; then
      increment_secure "Reserved ElastiCache instance $cache has more than 7 days remaining"
    else
      increment_insecure "Reserved ElastiCache instance $cache has less than 7 days remaining"
    fi
  done
}