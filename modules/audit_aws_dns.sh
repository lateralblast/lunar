# audit_aws_dns
#
# Ensure that AWS Route 53 Auto Renew feature is enabled to automatically renew
# your domain names as the expiration date approaches. The automatic renewal
# registration fee will be charged to your AWS account and you will get an email
# with the renewal confirmation once the registration is processed.
#
# Enabling automatic renewal for your domains registered with AWS or transferred
# to AWS will guarantee you full control over domain names registration.
# When your domains are automatically renewed before their expiration date,
# the risk of losing them is practically zero.
#
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-auto-renew.html
#.

audit_aws_dns () {
  domains=`aws route53domains list-domains --query 'Domains[].DomainName' --output text 2> /dev/null`
  for domain in $domains; do
    check=`aws route53domains get-domain-detail --domain-name $domain |grep true`
    if [ ! "$check" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   Domain $domain does not auto renew [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws route53domains enable-domain-auto-renew --domain-name $domain" fix
      funct_verbose_message "" fix

    else
      secure=`expr $secure + 1`
      echo "Secure:    Domain $domain auto renews [$secure Passes]"
    fi
  done
}

