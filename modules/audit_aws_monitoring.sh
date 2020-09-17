# audit_aws_monitoring
#
# Refer to Section(s) 3.1  Page(s) 87-9   CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 3.2  Page(s) 90-2   CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 3.3  Page(s) 93-6   CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 3.4  Page(s) 97-9   CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.5  Page(s) 100-2  CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.6  Page(s) 103-5  CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.7  Page(s) 106-7  CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.8  Page(s) 108-10 CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.9  Page(s) 111-3  CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.10 Page(s) 114-6  CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.11 Page(s) 117-9  CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.12 Page(s) 120-2  CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.13 Page(s) 123-5  CIS AWS Foundations Benchmark v1.1.0 
# Refer to Section(s) 3.14 Page(s) 126-8  CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/aws-config-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/authorization-failures-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/cmk-disabled-or-scheduled-for-deletion-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/cloudtrail-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/console-sign-in-failures-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/ec2-instance-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/iam-policy-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/internet-gateway-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/network-acl-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/root-account-usage-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/route-table-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/s3-bucket-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/securitygroup-changes-alarm.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/vpc-changes-alarm.html
#.

audit_aws_monitoring () {
  verbose_message "CloudWatch"
  trails=$( aws cloudtrail describe-trails --region $aws_region --query "trailList[].CloudWatchLogsLogGroupArn" --output text | awk -F':' '{print $7}' )
  if [ "$trails" ]; then
    increment_secure "CloudWatch log groups exits for CloudTrail"
    for trail in $trails; do
      metrics=$( aws logs describe-metric-filters --region $aws_region --log-group-name $trail --query "metricFilters[].filterPattern" --output text )
      if [ ! "$metrics" ]; then
        increment_insecure "CloudWatch log group $trail has no metrics"
        verbose_message "" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name unauthorized-api-calls-metric --metric-transformations metricName=unauthorized-api-calls-metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name no_mfa_console_signin_metric --metric-transformations metricName=no_mfa_console_signin_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name root_usage_metric --metric-transformations metricName=root_usage_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name iam_changes_metric --metric-transformations metricName=iam_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name cloudtrail_config_changes_metric --metric-transformations metricName=cloudtrail_cfg_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) ||($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name console_signin_failure_metric --metric-transformations metricName=console_signin_failure_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failedauthentication\") }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name disable_or_delete_cmk_metric --metric-transformations metricName=disable_or_delete_cmk_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion))}'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name s3_bucket_policy_changes_metric --metric-transformations metricName=s3_bucket_policy_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name aws_config_changes_metric --metric-transformations metricName=aws_config_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{($.eventSource = config.amazonaws.com) && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder))}'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name nacl_changes_metric --metric-transformations metricName=nacl_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name security_group_changes_metric --metric-transformations metricName=security_group_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.event Name = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name network_gateway_changes_metric --metric-transformations metricName=network_gw_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name route_table_changes_metric --metric-transformations metricName=route_table_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name vpc_changes_metric --metric-transformations metricName=vpc_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }'" fix
        verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name ec2_changes_metric --metric-transformations metricName=ec2_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = RunInstances) || ($.eventName = RebootInstances) || ($.eventName = StartInstances) || ($.eventName = StopInstances) || ($.eventName = TerminateInstances) }'" fix
        for sns_topic in unauthorized-api-calls no_mfa_console_signin root_usage iam_changes cloudtrail_config_changes console_signin_failure disable_or_delete_cmk \
                         s3_bucket_policy_changes aws_config_changes nacl_changes security_group network_gateway route_table_changes vpc_changes ec2_changes; do
           verbose_message "aws sns create-topic --region $aws_region --name $sns_topic" fix
           verbose_message "aws sns subscribe --region $aws_region --topic-arn $sns_topic --protocol $sns_protocol notification-endpoint $sns_endpoints" fix 
        done
        verbose_message "" fix
      else
        for metric in UnauthorizedOperation AccessDenied ConsoleLogin additionalEventData.MFAUsed userIdentity.invokedBy AwsServiceEvent \
                      DeleteGroupPolicy DeleteRolePolicy DeleteUserPolicy PutGroupPolicy PutRolePolicy PutUserPolicy CreatePolicy \
                      DeletePolicy CreatePolicyVersion DeletePolicyVersion AttachRolePolicy DetachRolePolicy AttachUserPolicy \
                      DetachUserPolicy AttachGroupPolicy DetachGroupPolicy CreateTrail UpdateTrail DeleteTrail StartLogging StopLogging \
                      Failedauthentication DisableKey ScheduleKeyDeletion PutBucketAcl PutBucketPolicy PutBucketCors PutBucketLifecycle \
                      PutBucketReplication DeleteBucketPolicy DeleteBucketCors DeleteBucketLifecycle DeleteBucketReplication \
                      StopConfigurationRecorder DeleteDeliveryChannel PutDeliveryChannel PutConfigurationRecorder AuthorizeSecurityGroupIngress \
                      AuthorizeSecurityGroupEgress RevokeSecurityGroupIngress RevokeSecurityGroupEgress CreateSecurityGroup DeleteSecurityGroup \
                      CreateNetworkAcl CreateNetworkAclEntry DeleteNetworkAcl DeleteNetworkAclEntry ReplaceNetworkAclEntry ReplaceNetworkAclAssociation \
                      CreateCustomerGateway DeleteCustomerGateway AttachInternetGateway CreateInternetGateway DeleteInternetGateway DetachInternetGateway \
                      CreateRoute CreateRouteTable ReplaceRoute ReplaceRouteTableAssociation DeleteRouteTable DeleteRoute DisassociateRouteTable \
                      CreateVpc DeleteVpc ModifyVpcAttribute AcceptVpcPeeringConnection CreateVpcPeeringConnection DeleteVpcPeeringConnection \
                      RejectVpcPeeringConnection AttachClassicLinkVpc DetachClassicLinkVpc DisableVpcClassicLink EnableVpcClassicLink \
                      TerminateInstances StopInstances StartInstances RebootInstances RunInstances; do
          check=$( aws logs describe-metric-filters --region $aws_region --log-group-name $trail --query "metricFilters[].filterPattern" --output text |grep "$metric" )
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
  alarms=$( aws cloudwatch describe-alarms --region $aws_region --query "MetricAlarms[].AlarmActions" --output text )
  if [ "$alarms" ]; then
    increment_secure "CloudWatch alarms exits for CloudTrail"
    for alarm in $alarms; do
      subscribers=$( aws sns list-subscriptions-by-topic --region $aws_region --topic-arn $alarm --output text )
      if [ "$subscribers" ]; then
        increment_secure "CloudWatch alarm $alarm has subscribers"
      else
        increment_insecure "CloudWatch alarm $alarm does not have subscribers"
      fi 
    done
  else
    increment_insecure "No CloudWatch alarms exist for CloudTrail"
  fi
}

