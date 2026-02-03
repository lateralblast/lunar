#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_rec_elb
#
# Check ELB Recommendations
# 
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-connection-draining-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-cross-zone-load-balancing-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-minimum-number-of-ec2-instances.html
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/unused-elastic-load-balancers.html
#.

audit_aws_rec_elb () {
  print_function  "audit_aws_rec_elb"
  verbose_message "ELB Recommendations" "check"
  command="aws elb describe-load-balancers --region \"${aws_region}\" --query \"LoadBalancerDescriptions[].LoadBalancerName\" --output text"
  command_message "${command}"
	elbs=$( eval "${command}" )
  for elb in ${elbs}; do
    command="aws elb describe-load-balancer-attributes --region \"${aws_region}\" --load-balancer-name \"${elb}\" --query \"LoadBalancerAttributes.ConnectionDraining\" | grep Enabled | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ ! "${check}" ]; then
      increment_insecure "ELB \"${elb}\" does not have connection draining enabled"
      verbose_message    "aws elb modify-load-balancer-attributes --region \"${aws_region}\" --load-balancer-name \"${elb}\" --load-balancer-attributes \"{\\\"ConnectionDraining\\\":{\\\"Enabled\\\":true, \\\"Timeout\\\":300}}\"" "fix"
    else
      increment_secure   "ELB \"${elb}\" has connection draining"
    fi
    command="aws elb describe-load-balancer-attributes --region \"${aws_region}\" --load-balancer-name \"${elb}\"  --query \"LoadBalancerAttributes.CrossZoneLoadBalancing\" | grep Enabled | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ ! "${check}" ]; then
      increment_insecure "ELB \"${elb}\" does not have cross zone balancing enabled"
    else
      increment_secure   "ELB \"${elb}\" has cross zone balancing enabled"
    fi
    command="aws elb describe-instance-health --region \"${aws_region}\" --load-balancer-name \"${elb}\"  --query \"InstanceStates[].State\" | grep -c InService"
    command_message "${command}"
    number=$( eval "${command}" )
    if [ "${number}" -lt 2 ]; then
      increment_insecure "ELB \"${elb}\" does not have at least 2 instances in service"
    else
      increment_secure   "ELB \"${elb}\" has at least two instances in service"
    fi
    command="aws elb describe-instance-health --region \"${aws_region}\" --load-balancer-name \"${elb}\"  --query \"InstanceStates[].InstanceState\" --filter ansible_value=state,Values='OutOfService' --output text"
    command_message "${command}"
    instances=$( eval "${command}" )
    for instance in ${instances}; do
      increment_insecure "ELB \"${elb}\" instance \"${instance}\" is out of service "
    done
  done
}

