# audit_aws_rec_elb
#
# With Connection Draining feature enabled, if an EC2 backend instance fails
# health checks the Elastic Load Balancer will not send any new requests to the
# unhealthy instance. However, it will still allow existing (in-flight) requests
# to complete for the duration of the configured timeout.
#
# Enabling this feature will allow better management of the resources behind the
# Elastic Load Balancer, such as replacing backend instances without impacting
# the user experience. For example, taking an instance out of service and
# replacing it with a fresh EC2 instance that contains updated software, while
# avoid breaking open network connections.
#
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-connection-draining-enabled.html
#.

audit_aws_rec_elb () {
	elbs=`aws elb describe-load-balancers --region $aws_region --query "LoadBalancerDescriptions[].LoadBalancerName" --output text`
  for elb in $elbs; do
    total=`expr $total + 1`
    check=`aws elb describe-load-balancer-attributes --region $aws_region --load-balancer-name $elb  --query "LoadBalancerAttributes.ConnectionDraining" |grep Enabled |grep true`
    if [ ! "$check" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   ELB $elb does not have connection draining enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws elb modify-load-balancer-attributes --region $aws_region --load-balancer-name $elb --load-balancer-attributes \"{\\\"ConnectionDraining\\\":{\\\"Enabled\\\":true, \\\"Timeout\\\":300}}\"" fix
      funct_verbose_message "" fix
    else
      secure=`expr $secure + 1`
      echo "Secure:    ELB $elb has connection draining [$secure Passes]"
    fi
  done
}

