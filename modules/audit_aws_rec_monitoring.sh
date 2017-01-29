# audit_aws_rec_monitoring
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/ec2-large-instance-changes-alarm.html
#.

audit_aws_rec_monitoring () {
	trails=`aws cloudtrail describe-trails --region $aws_region --query "trailList[].CloudWatchLogsLogGroupArn" --output text |awk -F':' '{print $7}'`
  total=`expr $total + 1`
  if [ "$trails" ]; then
    secure=`expr $secure + 1`
    echo "Secure:    CloudWatch log groups exits for CloudTrail [$secure Passes]"
    for trail in $trails; do
      total=`expr $total + 1`
      metrics=`aws logs describe-metric-filters --region $aws_region --log-group-name $trail --query "metricFilters[].filterPattern" --output text`
      if [ ! "$metrics" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudWatch log group $trail has no metrics [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name ec2_size_changes_metric --metric-transformations metricName=ec2_size_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = RunInstances) && (($.requestParameters.instanceType = *.8xlarge) || ($.requestParameters.instanceType = *.4xlarge)) }'" fix
        for sns_topic in ec2_size_changes; do
           funct_verbose_message "aws sns create-topic --region $aws_region --name $sns_topic" fix
           funct_verbose_message "aws sns subscribe --region $aws_region --topic-arn $sns_topic --protocol $sns_protocol notification-endpoint $sns_endpoints" fix 
        done
        funct_verbose_message "" fix
      else
        for metric in RunInstances instanceType ; do
          total=`expr $total + 1`
          check=`aws logs describe-metric-filters --region $aws_region --log-group-name $trail --query "metricFilters[].filterPattern" --output text |grep "$metric"`
          if [ "$check" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    CloudWatch log group $trail metrics include $metric [$secure Passes]"
          else
            insecure=`expr $insecure + 1`
            echo "Warning:   CloudWatch log groups $trail metrics do not include $metric [$insecure Warnings]"
          fi
        done
      fi
    done
  else
    insecure=`expr $insecure + 1`
    echo "Warning:   No CloudWatch log groups exist for CloudTrail [$insecure Warnings]"
  fi
}

