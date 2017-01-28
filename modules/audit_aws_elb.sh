# audit_aws_elb
#
# Ensure ELB SSL policies do not have deprecated ciphers and protocols
#
# Refer to http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html
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
#
# Check your Elastic Load Balancers Secure Socket Layer (SSL) negotiation
# configuration (security policy) for any cipher suites that demonstrate
# vulnerabilities or have been rendered insecure by recent exploits.
#
# Using insecure and deprecated ciphers for your ELB Predefined Security Policy
# or Custom Security Policy could make the SSL connection between the client
# and the load balancer vulnerable to exploits. If your ELB SSL negotiation
# configuration use outdated cipher suites, we highly recommend that you update
# it using the information provided in this guide (see Remediation/Resolution
# section).
#
# https://www.cloudconformity.com/conformity-rules/ELB/elb-insecure-ssl-ciphers.html
#
# Check your Elastic Load Balancers Secure Sockets Layer (SSL) negotiation
# configuration for SSLv2 and SSLv3 insecure / deprecated SSL protocols.
#
# Using insecure and deprecated protocols for your ELB Predefined Security
# Policy or Custom Security Policy could make the connection between the client
# and the load balancer vulnerable to exploits such as DROWN (Decrypting RSA
# using Obsolete and Weakened eNcryption), which targets a specific weakness in
# the OpenSSL implementation of SSLv2 protocol and POODLE (Padding Oracle On
# Downgraded Legacy Encryption).
#
# This vulnerability allows an attacker to read information encrypted with SSLv3
# protocol in plain text, using a man-in-the-middle attack. If your existent ELB
# SSL negotiation configuration use Protocol-SSLv2 and/or Protocol-SSLv3,
# we highly recommend updating it.
#
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-insecure-ssl-protocols.html
#
# Check your Elastic Load Balancers (ELBs) listener for secure configurations.
# Cloud Conformity recommends using HTTPS or SSL protocols to encrypt th
# communication between the client and your load balancers.
#
# When an ELB has no listener configured to use secure protocols like HTTPS or
# SSL, the front-end connection between the client and the load balancer is
# vulnerable to eavesdropping and man-in-the-middle (MITM) attacks. The risk
# becomes even higher when transmitting sensitive private data such as credit
# card numbers. If your ELBs are not using secure listeners (HTTPS or SSL),
# apply the information provided in this guide (see Remediation/Resolution
# section) to update their configuration.
#
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-listener-security.html
#
# Check your Elastic Load Balancer (ELB) security layer for at least one valid
# security group that restrict access only to the ports defined in the load
# balancer listeners configuration.
#
# Refer to https://www.cloudconformity.com/conformity-rules/ELB/elb-security-group.html
#.

audit_aws_elb () {
  # Ensure ELBs have logging enabled
	elbs=`aws elb describe-load-balancers --region $aws_region --query "LoadBalancerDescriptions[].LoadBalancerName" --output text`
  for elb in $elbs; do
    total=`expr $total + 1`
    check=`aws elb describe-load-balancers --region $aws_region --load-balancer-name $elb  --query "LoadBalancerDescriptions[].AccessLog" |grep true`
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
    # Ensure ELBs are not using HTTP
    total=`expr $total + 1`
    protocol=`aws elb describe-load-balancers --region $aws_region --load-balancer-name $elb  --query "LoadBalancerDescriptions[].ListenerDescriptions[].Listener.Protcol" --output text`
    if [ "$protocol" = "HTTP" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   ELB $elb is using HTTP [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    ELB $elb is not using HTTP [$secure Passes]"
    fi
    # Ensure ELB SGs do not have port 80 open to the world
    sgs=`aws elb describe-load-balancers --region $aws_region --load-balancer-name $elb  --query "LoadBalancerDescriptions[].SecurityGroups" --output text`
    for sg in $sgs; do
      funct_aws_open_port_check $sg 80 tcp HTTP ELB $elb
    done
    # Ensure no deprecated ciphers of protocols are being used
    policies=`aws elb describe-load-balancer-policies --region $aws_region --load-balancer-name $elb  --query "PolicyDescriptions[].PolicyName" --output text`
    for policy in $policies; do
      for cipher in SSLv2 RC2-CBC-MD5 PSK-AES256-CBC-SHA PSK-3DES-EDE-CBC-SHA KRB5-DES-CBC3-SHA KRB5-DES-CBC3-MD5 \
                    PSK-AES128-CBC-SHA PSK-RC4-SHA KRB5-RC4-SHA KRB5-RC4-MD5 KRB5-DES-CBC-SHA KRB5-DES-CBC-MD5 \
                    EXP-EDH-RSA-DES-CBC-SHA EXP-EDH-DSS-DES-CBC-SHA EXP-ADH-DES-CBC-SHA EXP-DES-CBC-SHA \
                    SSLv3 EXP-RC2-CBC-MD5 EXP-KRB5-RC2-CBC-SHA EXP-KRB5-DES-CBC-SHA EXP-KRB5-RC2-CBC-MD5 \
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
