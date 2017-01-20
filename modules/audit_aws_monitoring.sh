# audit_aws_monitoring
#
# Real-time monitoring of API calls can be achieved by directing CloudTrail Logs
# to CloudWatch Logs and establishing corresponding metric filters and alarms.
# It is recommended that a metric filter and alarm be established for
# unauthorized API calls.
#
# Monitoring unauthorized API calls will help reveal application errors and may
# reduce time to detect malicious activity.
#
# Refer to Section(s) 3.1 Page(s) 87-9 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 3.2 Page(s) 90-1 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_monitoring () {
	trails=`aws cloudtrail describe-trails --query "trailList[].CloudWatchLogsLogGroupArn" --output text |awk -F':' '{print $7}'`
  total=`expr $total + 1`
  if [ "$trails" ]; then
    secure=`expr $secure + 1`
    echo "Secure:    CloudWatch log groups exits for CloudTrail [$secure Passes]"
    for trail in $trails; do
      total=`expr $total + 1`
      metrics=`aws logs describe-metric-filters --log-group-name $trail --query "metricFilters[].filterPattern" --output text`
      if [ ! "$metrics" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudWatch log group $trail has no metrics [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "aws logs put-metric-filter --log-group-name $trail --filter-name unauthorized-api-calls-metric --metric-transformations metricName=unauthorized-api-calls-metric,metricNamespace='CISBenchmark',metricValue=1 --filter-pattern '{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }'" fix
        funct_verbose_message "aws logs put-metric-filter --log-group-name $trail --filter-name no_mfa_console_signin_metric --metric-transformations metricName=no_mfa_console_signin_metric,metricNamespace='CISBenchmark',metricValue=1 --filter-pattern '{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }'" fix
        funct_verbose_message "" fix
      else
        for metric in UnauthorizedOperation AccessDenied ConsoleLogin additionalEventData.MFAUsed; do
          total=`expr $total + 1`
          check=`aws logs describe-metric-filters --log-group-name $trail --query "metricFilters[].filterPattern" --output text |grep "$metric"`
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
  alarms=`aws cloudwatch describe-alarms --query "MetricAlarms[].AlarmActions" --output text`
  total=`expr $total + 1`
  if [ "$alarms" ]; then
    secure=`expr $secure + 1`
    echo "Secure:    CloudWatch alarms exits for CloudTrail [$secure Passes]"
    for alarm in $alarms; do
      subscribers=`aws sns list-subscriptions-by-topic --topic-arn $alarm --output text`
      if [ "$subscribers" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    CloudWatch alarm $alarm has subscribers [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   CloudWatch alarm $alarm does not have subscribers [$insecure Warnings]"
      fi 
    done
  else
    insecure=`expr $insecure + 1`
    echo "Warning:   No CloudWatch alarms exist for CloudTrail [$insecure Warnings]"
  fi
}

