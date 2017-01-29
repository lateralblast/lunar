# audit_aws_dns
#
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-auto-renew.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-expired.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/sender-policy-framework-record-present.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-transfer-lock.html
#.

audit_aws_dns () {
  domains=`aws route53domains list-domains --query 'Domains[].DomainName' --output text 2> /dev/null`
  for domain in $domains; do
    total=`expr $total + 1`
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
    total=`expr $total + 1`
    cur_secs=`date "+%s"`
    exp_secs=`aws route53domains get-domain-detail --domain-name $domain --query "ExpirationDate" --output text 2> /dev/null`
    if [ "$exp_secs" -lt "$cur_secs" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   Domain $domain registration has expired [$insecure Warnings]" 
    else
      secure=`expr $secure + 1`
      echo "Secure:    Domain $domain registration has not expired [$secure Passes]"
    fi
    total=`expr $total + 1`
    check=`aws route53domains get-domain-detail --domain-name $domain --query "Status" --output text 2> /dev/null | grep clientTransferProhibited`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Domain $domain has Domain Transfer Lock enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Domain $domain does not have Domain Transfer Lock enabled [$insecure Warnings]" 
    fi
  done
  zones=`aws route53 list-hosted-zones --query "HostedZones[].Id" --output text 2> /dev/null |cut -f3 -d'/'`
  for zone in $zones; do
    total=`expr $total + 1`
    spf=`aws route53 list-resource-record-sets --hosted-zone-id $zone --query "ResourceRecordSets[?Type == 'SPF']" --output text`
    if [ "$spf" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Zone $zone has SPF records [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Zone $zone does not have SPF records [$insecure Warnings]" 
    fi
  done
}

