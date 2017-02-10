# audit_aws_rec_elb
#
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-connection-draining-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-cross-zone-load-balancing-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-minimum-number-of-ec2-instances.html
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/unused-elastic-load-balancers.html
#.

audit_aws_rec_elb () {
	elbs=`aws elb describe-load-balancers --region $aws_region --query "LoadBalancerDescriptions[].LoadBalancerName" --output text`
  for elb in $elbs; do
    total=`expr $total + 1`
    check=`aws elb describe-load-balancer-attributes --region $aws_region --load-balancer-name $elb  --query "LoadBalancerAttributes.ConnectionDraining" |grep Enabled |grep true`
    if [ ! "$check" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   ELB $elb does not have connection draining enabled [$insecure Warnings]"
      verbose_message "" fix
      verbose_message "aws elb modify-load-balancer-attributes --region $aws_region --load-balancer-name $elb --load-balancer-attributes \"{\\\"ConnectionDraining\\\":{\\\"Enabled\\\":true, \\\"Timeout\\\":300}}\"" fix
      verbose_message "" fix
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
    total=`expr $total + 1`
    number=`aws elb describe-instance-health --region $aws_region --load-balancer-name $elb  --query "InstanceStates[].State" |grep InService |wc -l`
    if [ "$number" -lt 2 ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   ELB $elb does not have at least 2 instances in service [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    ELB $elb has at least two instances in service [$secure Passes]"
    fi
    instances=`aws elb describe-instance-health --region $aws_region --load-balancer-name $elb  --query "InstanceStates[].InstanceState" --filter Name=state,Values='OutOfService' --output text`
    for instance in $instances; do
      total=`expr $total + 1`
      insecure=`expr $insecure + 1`
      echo "Warning:   ELB $elb instance $instance is out of service  [$insecure Warnings]"
    done
  done
}

