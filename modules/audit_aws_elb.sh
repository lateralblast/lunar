# audit_aws_elb
#
# Ensure that your AWS Elastic Load Balancers use access logging to analyze
# traffic patterns and identify and troubleshoot security issues.
#
# Enabling this feature will allow your ELB to record and save information about
# each TCP and HTTP request made for your backend instances. The access logging
# data can be extremely useful for security audits and troubleshooting sessions.
# For example your ELB logging data can be used to analyze traffic patterns in
# order to detect different types of attacks and help implementing custom
# protection plans.
#
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-access-log.html
#.

audit_aws_elb () {
	elbs=`aws elb describe-load-balancers --region $aws_region --query "LoadBalancerDescriptions[].LoadBalancerName" --output text`
  for elb in $elbs; do
    total=`expr $total + 1`
    check=`aws elb describe-load-balancer-attributes --region $aws_region --load-balancer-name $elb  --query "LoadBalancerDescriptions[].AccessLog" |grep true`
    if [ ! "$check" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   ELB $elb does not have access logging enabled [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    ELB $elb has access logging enabled [$secure Passes]"
    fi
  done
}

