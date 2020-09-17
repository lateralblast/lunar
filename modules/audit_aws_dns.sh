# audit_aws_dns
#
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-auto-renew.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-expired.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/sender-policy-framework-record-present.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-transfer-lock.html
#.

audit_aws_dns () {
  verbose_message "Route53"
  domains=$( aws route53domains list-domains --query 'Domains[].DomainName' --output text 2> /dev/null )
  for domain in $domains; do
    check=$( aws route53domains get-domain-detail --domain-name $domain | grep true )
    if [ ! "$check" ]; then
      increment_insecure "Domain $domain does not auto renew"
      lockdown_command "aws route53domains enable-domain-auto-renew --domain-name $domain"
    else
      increment_secure "Domain $domain auto renews"
    fi
    cur_secs=$( date "+%s" )
    exp_secs=$( aws route53domains get-domain-detail --domain-name $domain --query "ExpirationDate" --output text 2> /dev/null )
    if [ "$exp_secs" -lt "$cur_secs" ]; then
      increment_insecure "Warning:   Domain $domain registration has expired" 
    else
      increment_secure "Domain $domain registration has not expired"
    fi
    check=$( aws route53domains get-domain-detail --domain-name $domain --query "Status" --output text 2> /dev/null | grep clientTransferProhibited )
    if [ "$check" ]; then
      increment_secure "Domain $domain has Domain Transfer Lock enabled"
    else
      increment_insecure "Domain $domain does not have Domain Transfer Lock enabled" 
    fi
  done
  zones=$( aws route53 list-hosted-zones --query "HostedZones[].Id" --output text 2> /dev/null | cut -f3 -d'/' )
  for zone in $zones; do
    spf=$( aws route53 list-resource-record-sets --hosted-zone-id $zone --query "ResourceRecordSets[?Type == 'SPF']" --output text )
    if [ "$spf" ]; then
      increment_secure "Zone $zone has SPF records"
    else
      increment_insecure "Zone $zone does not have SPF records" 
    fi
  done
}

