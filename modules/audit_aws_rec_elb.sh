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
#
# By using at least two subnets in different Availability Zones with the
# Cross-Zone Load Balancing feature enabled, your ELBs can distribute the
# traffic evenly across all backend instances. To use Cross-Zone Load
# Balancing at optimal level, Amazon recommends maintaining an equal EC2
# capacity distribution in each of the AZs registered with the load balancer.
#
# Enabling Cross-Zone Load Balancing makes it easier to deploy and manage
# applications that run across multiple subnets in different Availability Zones.
# This would also guarantee better fault tolerance and more consistent traffic
# flow. If one of the availability zones registered with the ELB fails (as
# result of network outage or power loss), the load balancer with the Cross-Zone
# Load Balancing activated would act as a traffic guard, stopping any request
# being sent to the unhealthy zone and routing it to the other zone(s).
#
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-cross-zone-load-balancing-enabled.html
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
    total=`expr $total + 1`
    check=`aws elb describe-load-balancer-attributes --region $aws_region --load-balancer-name $elb  --query "LoadBalancerAttributes.CrossZoneLoadBalancing" |grep Enabled |grep true`
    if [ ! "$check" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   ELB $elb does not have cross zone balancing enabled [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    ELB $elb has cross zone balancing enabled [$secure Passes]"
    fi
  done
}

