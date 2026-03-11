#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_dns
#
# Check AWS DNS
# 
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-auto-renew.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-expired.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/sender-policy-framework-record-present.html
# Refer to https://www.cloudconformity.com/conformity-rules/Route53/route-53-domain-transfer-lock.html
#.

audit_aws_dns () {
  print_function  "audit_aws_dns"
  check_message   "Route53"
  command="aws route53domains list-domains --query 'Domains[].DomainName' --output text 2> /dev/null"
  command_message "${command}"
  domains=$( eval "${command}" )
  for domain in ${domains}; do
    command="aws route53domains get-domain-detail --domain-name \"${domain}\" | grep true"
    command_message "${command}"
    check=$( eval   "${command}" )
    if [ -z "${check}" ]; then
      inc_insecure     "Domain ${domain} does not auto renew"
      lockdown_command="aws route53domains enable-domain-auto-renew --domain-name ${domain}"
      lockdown_message="Auto-Renew on Domain \"${domain}\" to enabled"
      exec_lockdown    "${lockdown_command}" "${lockdown_message}" "sudo"
    else
      inc_secure       "Domain \"${domain}\" auto renews"
    fi
    command="date \"+%s\""
    command_message  "${command}"
    cur_secs=$( eval "${command}" )
    command="aws route53domains get-domain-detail --domain-name \"${domain}\" --query \"ExpirationDate\" --output text 2> /dev/null"
    command_message  "${command}"
    exp_secs=$( eval "${command}" )
    if [ "${exp_secs}" -lt "${cur_secs}" ]; then
      inc_insecure   "Warning:   Domain \"${domain}\" registration has expired" 
    else
      inc_secure     "Domain \"${domain}\" registration has not expired"
    fi
    command="aws route53domains get-domain-detail --domain-name \"${domain}\" --query \"Status\" --output text 2> /dev/null | grep clientTransferProhibited"
    command_message  "${command}"
    check=$( eval    "${command}" )
    if [ -n "${check}" ]; then
      inc_secure     "Domain \"${domain}\" has Domain Transfer Lock enabled"
    else
      inc_insecure   "Domain \"${domain}\" does not have Domain Transfer Lock enabled" 
    fi
  done
  command="aws route53 list-hosted-zones --query \"HostedZones[].Id\" --output text 2> /dev/null | cut -f3 -d'/'"
  command_message    "${command}"
  zones=$( eval      "${command}" )
  for zone in ${zones}; do
    command="aws route53 list-resource-record-sets --hosted-zone-id \"${zone}\" --query \"ResourceRecordSets[?Type == 'SPF']\" --output text"
    command_message  "${command}"
    spf=$( eval      "${command}" )
    if [ -n "${spf}" ]; then
      inc_secure     "Zone \"${zone}\" has SPF records"
    else
      inc_insecure   "Zone \"${zone}\" does not have SPF records" 
    fi
  done
}

