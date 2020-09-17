# audit_aws_rec_redshift
#
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/reserved-nodes-expiration.html
#.

audit_aws_rec_redshift () {
  verbose_message "Redshift Recommendations"
  dbs=$( aws redshift describe-reserved-nodes --region $aws_region --query 'ReservedNodes[].ReservedNodeId' --output text )
  for db in $dbs; do
    start_date=$( aws redshift describe-reserved-nodes --region $aws_region --reserved-node-id $db --query 'ReservedNodes[].StartTime' --output text | cut -f1 -d. )
    dur_secs=$( aws redshift describe-reserved-nodes --region $aws_region --reserved-node-id $db --query 'ReservedNodes[].Duration' --output text )
    curr_secs=$( date "+%s" )
    if [ "$os_name" = "Linux" ]; then
      start_secs=$( date -d "$start_date" "+%s" )
    else
      start_secs=$( date -j -f "%Y-%m-%dT%H:%M:%SS" "$start_date" "+%s" )
    fi
    exp_secs=$( echo "($start_secs + $dur_secs)" | bc )
    test_secs=$( echo "(7 * 84600)" | bc )
    left_secs=$( echo "($exp_secs - $curr_secs)" | bc )
    if [ "$left_secs" -lt "$test_secs" ]; then
      increment_secure "Reserved Redshift instance $db has more than 7 days remaining"
    else
      increment_insecure "Reserved Redshift instance $db has less than 7 days remaining"
    fi
  done
}
