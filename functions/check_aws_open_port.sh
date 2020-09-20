# check_aws_open_port
#
# Check AWS Security Groups for open ports, i.e. CIDR of 0.0.0.0/0
#
# This requires the AWS CLI to be installed and configured
#.

check_aws_open_port () {
  sg=$1
  port=$2
  protocol=$3
  service=$4
  app=$5
  instance=$6
  open_port=$( aws ec2 describe-security-groups --region $aws_region --group-ids $sg --filters "Name=ip-permission.to-port,Values=$port" "Name=ip-permission.cidr,Values=0.0.0.0/0" "Name=ip-permission.protocol,Values=$protocol" --output text )
  if [ ! "$open_port" ]; then
    if [ "$app" = "none" ]; then
      increment_secure "Security Group $sg does not have $service on port $port open to the world"
    else
      increment_secure "$app $instance with Security Group $sg does not have $service on port $port open to the world"
    fi
  else
    if [ "$app" = "none" ]; then
      increment_insecure "Security Group $sg has $service on port $port open to the world"
    else
      increment_insecure "$app $instance with Security Group $sg has $service on port $port open to the world"
    fi
    lockdown_command "aws ec2 revoke-security-group-ingress --region $aws_region --group-name $sg --protocol $protocol --port $port --cidr 0.0.0.0/0" fix
  fi
}
