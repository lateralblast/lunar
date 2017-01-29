# audit_aws_monitoring
#
# Real-time monitoring of API calls can be achieved by directing CloudTrail Logs
# to CloudWatch Logs and establishing corresponding metric filters and alarms.
#
# It is recommended that a metric filter and alarm be established for
# unauthorized API calls.
#
# Monitoring unauthorized API calls will help reveal application errors and may
# reduce time to detect malicious activity.
#
# It is recommended that a metric filter and alarm be established for console
# logins that are not protected by multi-factor authentication (MFA).
#
# Monitoring for single-factor console logins will increase visibility into
# accounts that are not protected by MFA.
#
# It is recommended that a metric filter and alarm be established for root
# login attempts.
#
# Monitoring for root account logins will provide visibility into the use of a
# fully privileged account and an opportunity to reduce the use of it.
#
# It is recommended that a metric filter and alarm be established changes
# made to Identity and Access Management (IAM) policies.
#
# Monitoring changes to IAM policies will help ensure authentication and
# authorization controls remain intact.
#
# It is recommended that a metric filter and alarm be established for detecting
# changes to CloudTrail's configurations.
#
# Monitoring changes to CloudTrail's configuration will help ensure sustained
# visibility to activities performed in the AWS account.
#
# It is recommended that a metric filter and alarm be established for failed
# console authentication attempts.
#
# Monitoring failed console logins may decrease lead time to detect an attempt
# to brute force a credential, which may provide an indicator, such as source
# IP, that can be used in other event correlation.
#
# It is recommended that a metric filter and alarm be established for customer
# created CMKs which have changed state to disabled or scheduled deletion.
# 
# Data encrypted with disabled or deleted keys will no longer be accessible.
#
# It is recommended that a metric filter and alarm be established for changes
# to S3 bucket policies.
#
# Monitoring changes to S3 bucket policies may reduce time to detect and correct
# permissive policies on sensitive S3 buckets.
#
# It is recommended that a metric filter and alarm be established for detecting
# changes to CloudTrail's configurations.
#
# Monitoring changes to AWS Config configuration will help ensure sustained
# visibility of configuration items within the AWS account.
#
# Security Groups are a stateful packet filter that controls ingress and egress
# traffic within a VPC. It is recommended that a metric filter and alarm be
# established changes to Security Groups.
#
# Monitoring changes to security group will help ensure that resources and
# services are not unintentionally exposed.
#
# NACLs are used as a stateless packet filter to control ingress and egress
# traffic for subnets within a VPC. It is recommended that a metric filter and
# alarm be established for changes made to NACLs.
#
# Monitoring changes to NACLs will help ensure that AWS resources and services
# are not unintentionally exposed.
#
# Network gateways are required to send/receive traffic to a destination
# outside of a VPC. It is recommended that a metric filter and alarm be
# established for changes to network gateways.
#
# Monitoring changes to network gateways will help ensure that all
# ingress/egress traffic traverses the VPC border via a controlled path.
#
# Routing tables are used to route network traffic between subnets and to
# network gateways. It is recommended that a metric filter and alarm be
# established for changes to route tables.
#
# Monitoring changes to route tables will help ensure that all VPC traffic flows
# through an expected path.
#
# It is possible to have more than 1 VPC within an account, in addition it is
# also possible to create a peer connection between 2 VPCs enabling network
# traffic to route between VPCs. It is recommended that a metric filter and
# alarm be established for changes made to VPCs.
#
# Monitoring changes to IAM policies will help ensure authentication and
# authorization controls remain intact.
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
#
# Ensure there is an Amazon CloudWatch alarm created and configured in your AWS
# account to fire each time an AWS Config configuration change is made. This
# CloudWatch alarm must be triggered every time an AWS API call is performed to
# Stop Configuration Recorder, Delete Delivery Channel, Put Delivery Channel,
# or Put Configuration Recorder. 
#
# Using Amazon CloudWatch alarms to detect environment configuration changes
# involving your AWS Config will help you prevent any accidental or intentional
# modifications that may lead to unauthorized network access or other security
# breaches.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/aws-config-changes-alarm.html
#
# Ensure there is a CloudWatch alarm created in your account that is triggered
# each time an unauthorized API call is made in order to respond quickly to any
# unapproved actions detected.
#
# Using CloudWatch alarms to detect unauthorized AWS API requests can help you
# keep the AWS account secure. For example, when managing the permissions of a
# large number of IAM users mistakes can be made and certain users can receive
# unintended IAM API access. With CloudWatch alarms these unintended API calls
# can be automatically detected, enabling you to act fast and revoke their
# access.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/authorization-failures-alarm.html
#
# Ensure there is an Amazon CloudWatch alarm created and configured in your AWS
# account to fire each time an AWS CMK configuration change is made. This
# CloudWatch alarm must be triggered every time an AWS API call is performed to
# Disable Key, or Schedule Key Deletion.
#
# Using Amazon CloudWatch alarms to detect environment configuration changes
# involving your AWS KMS Customer Master Keys will help you prevent any
# accidental or intentional modifications that may lead to unprotected data
# access or other security breaches.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/cmk-disabled-or-scheduled-for-deletion-alarm.html
#
# Ensure there is a CloudWatch alarm created in your AWS account that is
# triggered each time a configuration change is made at the CloudTrail service
# level. The alarm must fire when an API call is made to create, update or
# delete an AWS CloudTrail trail or when the logging process defined by a trail
# is stopped or started.
#
# Using CloudWatch alarms to detect AWS CloudTrail config changes can help you
# to maintain the integrity of the service configuration and prevent AWS users
# from covering their tracks after performing unauthorized actions within your
# AWS account.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/cloudtrail-changes-alarm.html
#
# Ensure there is a CloudWatch alarm created in your account that is triggered
# when there are three or more AWS Management Console sign-in failures during
# a five minute period.
#
# Using AWS CloudWatch alarms to monitor your AWS Console authentication process
# will help you to plan and implement the appropriate security measures in order
# to protect your account against brute-force attacks.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/console-sign-in-failures-alarm.html
#
# Ensure there is an Amazon CloudWatch alarm available in your AWS account that
# is triggered each time an AWS EC2 instance configuration and status change is
# made. This CloudWatch alarm must fire every time an AWS API call is performed
# to create, terminate, start, stop or reboot an EC2 instance.
#
# Using Amazon CloudWatch alarms to detect EC2 instance configuration and status
# changes will help you stay up-to-date on the resource availability, gain
# insights into auto-scaling lifecycle, mitigate downtime, prevent data loss or
# avoid unexpected charges on your AWS bill.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudWatchLogs/ec2-instance-changes-alarm.html
#.

audit_aws_monitoring () {
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
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name unauthorized-api-calls-metric --metric-transformations metricName=unauthorized-api-calls-metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name no_mfa_console_signin_metric --metric-transformations metricName=no_mfa_console_signin_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name root_usage_metric --metric-transformations metricName=root_usage_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name iam_changes_metric --metric-transformations metricName=iam_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name cloudtrail_config_changes_metric --metric-transformations metricName=cloudtrail_cfg_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) ||($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name console_signin_failure_metric --metric-transformations metricName=console_signin_failure_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failedauthentication\") }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name disable_or_delete_cmk_metric --metric-transformations metricName=disable_or_delete_cmk_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion))}'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name s3_bucket_policy_changes_metric --metric-transformations metricName=s3_bucket_policy_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name aws_config_changes_metric --metric-transformations metricName=aws_config_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{($.eventSource = config.amazonaws.com) && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder))}'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name nacl_changes_metric --metric-transformations metricName=nacl_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name security_group_changes_metric --metric-transformations metricName=security_group_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.event Name = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name network_gateway_changes_metric --metric-transformations metricName=network_gw_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name route_table_changes_metric --metric-transformations metricName=route_table_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name vpc_changes_metric --metric-transformations metricName=vpc_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }'" fix
        funct_verbose_message "aws logs put-metric-filter --region $aws_region --log-group-name $trail --filter-name ec2_changes_metric --metric-transformations metricName=ec2_changes_metric,metricNamespace='Audit',metricValue=1 --filter-pattern '{ ($.eventName = RunInstances) || ($.eventName = RebootInstances) || ($.eventName = StartInstances) || ($.eventName = StopInstances) || ($.eventName = TerminateInstances) }'" fix
        for sns_topic in unauthorized-api-calls no_mfa_console_signin root_usage iam_changes cloudtrail_config_changes console_signin_failure disable_or_delete_cmk \
                         s3_bucket_policy_changes aws_config_changes nacl_changes security_group network_gateway route_table_changes vpc_changes ec2_changes; do
           funct_verbose_message "aws sns create-topic --region $aws_region --name $sns_topic" fix
           funct_verbose_message "aws sns subscribe --region $aws_region --topic-arn $sns_topic --protocol $sns_protocol notification-endpoint $sns_endpoints" fix 
        done
        funct_verbose_message "" fix
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
  alarms=`aws cloudwatch describe-alarms --region $aws_region --query "MetricAlarms[].AlarmActions" --output text`
  total=`expr $total + 1`
  if [ "$alarms" ]; then
    secure=`expr $secure + 1`
    echo "Secure:    CloudWatch alarms exits for CloudTrail [$secure Passes]"
    for alarm in $alarms; do
      subscribers=`aws sns list-subscriptions-by-topic --region $aws_region --topic-arn $alarm --output text`
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

