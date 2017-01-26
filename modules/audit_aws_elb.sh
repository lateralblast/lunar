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
      funct_verbose_message "" fix
      funct_verbose_message "aws elb modify-load-balancer-attributes --region $aws_region --load-balancer-name $elb --load-balancer-attributes \"{\\\"AccessLog\\\":{\\\"Enabled\\\":true,\\\"EmitInterval\\\":60,\\\"S3BucketName\\\":\\\"elb-logging-bucket\\\"}}\"" fix
      funct_verbose_message "" fix
    else
      secure=`expr $secure + 1`
      echo "Secure:    ELB $elb has access logging enabled [$secure Passes]"
    fi
    policies=`aws elb describe-load-balancer-policies --region $aws_region --region $aws_region --load-balancer-name $elb  --query "PolicyDescriptions[].PolicyName" --output text`
    for policy in $policies; do
      for cipher in RC2-CBC-MD5 PSK-AES256-CBC-SHA PSK-3DES-EDE-CBC-SHA KRB5-DES-CBC3-SHA KRB5-DES-CBC3-MD5 \
                    PSK-AES128-CBC-SHA PSK-RC4-SHA KRB5-RC4-SHA KRB5-RC4-MD5 KRB5-DES-CBC-SHA KRB5-DES-CBC-MD5 \
                    EXP-EDH-RSA-DES-CBC-SHA EXP-EDH-DSS-DES-CBC-SHA EXP-ADH-DES-CBC-SHA EXP-DES-CBC-SHA \
                    EXP-RC2-CBC-MD5 EXP-KRB5-RC2-CBC-SHA EXP-KRB5-DES-CBC-SHA EXP-KRB5-RC2-CBC-MD5 \
                    EXP-KRB5-DES-CBC-MD5 EXP-ADH-RC4-MD5 EXP-RC4-MD5 EXP-KRB5-RC4-SHA EXP-KRB5-RC4-MD5; do
        total=`expr $total + 1`
        check=`aws elb describe-load-balancer-policies --region $aws_region --load-balancer-name $elb |grep $cipher |grep true`
        if [ "$check" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   ELB $elb is using deprecated cipher $cipher [$insecure Warnings]"
        else
          secure=`expr $secure + 1`
          echo "Secure:    ELB $elb is not using deprecated cipher $cipher [$secure Passes]"
        fi
      done
    done
  done
}

