# audit_aws_rec_monitoring
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/ec2-large-instance-changes-alarm.html
#.

audit_aws_rec_monitoring () {
  verbose_message "CloudWatch Recommendations"
  trails=$( aws cloudtrail describe-trails --region $aws_region --query "trailList[].CloudWatchLogsLogGroupArn" --output text |awk -F':' '{print $7}' )
  if [ "$trails" ]; then
    increment_secure "CloudWatch log groups exits for CloudTrail"
    for trail in $trails; do
      metrics=$( aws logs describe-metric-filters --region $aws_region --log-group-name $trail --query "metricFilters[].filterPattern" --output text )
      if [ ! "$metrics" ]; then
        increment_insecure "CloudWatch log group $trail has no metrics"
        verbose_message "" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name ec2_size_changes_metric --metric-transformations metricName=ec2_size_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = RunInstances) && (($.requestParameters.instanceType = *.8xlarge) || ($.requestParameters.instanceType = *.4xlarge)) }'" fix
        for sns_topic in ec2_size_changes; do
           verbose_message "aws sns create-topic --region $aws_region --name $sns_topic" fix
           verbose_message "aws sns subscribe --region $aws_region --topic-arn $sns_topic --protocol $sns_protocol notification-endpoint $sns_endpoints" fix 
        done
        verbose_message "" fix
      else
        for metric in RunInstances instanceType ; do
          check=$( aws logs describe-metric-filters --region $aws_region --log-group-name $trail --query "metricFilters[].filterPattern" --output text | grep "$metric" )
          if [ "$check" ]; then
            increment_secure "CloudWatch log group $trail metrics include $metric"
          else
            increment_insecure "CloudWatch log groups $trail metrics do not include $metric"
          fi
        done
      fi
    done
  else
    increment_insecure "No CloudWatch log groups exist for CloudTrail"
  fi
}

