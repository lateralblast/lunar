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
#
# Identify and restore any expired domain names registered with AWS Route 53.
# The restoration fee will be charged to your AWS account and you will get a 
# confirmation email once the registration process is completed.
#
# When the expired domain names are not restored promptly, they will become
# available for others to register. Restoring on time your Route 53 expired
# domains will allow you to reestablish full control over their registration.
#
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-expired.html
# 
# Ensure your AWS Route 53 hosted zones have a TXT DNS record that contains a
# corresponding Sender Policy Framework (SPF) value set for each MX record
# available. The SPF record enables your Route 53 registered domains to publicly
# state which mail servers are authorized to send emails on its behalf.
#
# Implementing SPF (Sender Policy Framework) records for your AWS Route 53
# domain names will help you detect and stop email address spoofing in
# order to reduce spam and increase your domains trustworthiness.
#
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/sender-policy-framework-record-present.html
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

