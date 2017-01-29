# audit_aws_es
#
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/elasticsearch-domain-exposed.html
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/elasticsearch-accessible-only-from-whitelisted-ip-addresses.html
#.

audit_aws_es () {
  domains=`aws es list-domain-names --region $aws_region --query "DomainNames[].DomainName" --output text`
  for domain in $domains; do
    total=`expr $total + 1`
    check=`aws es describe-elasticsearch-domain --domain-name $domain --query 'DomainStatus.AccessPolicies' --output text |grep Principle | grep "{\"AWS\":\"\*\"}"`
    if [ ! "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Elasticsearch doamin $domain is not publicly accessible [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Elasticsearch domain $domain is publicly accessible [$insecure Warnings]"
    fi
    total=`expr $total + 1`
    check=`aws es describe-elasticsearch-domain --domain-name $domain --query 'DomainStatus.AccessPolicies' --output text |grep "aws:SourceIp" |grep "[0-9]\."`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Elasticsearch doamin $domain has an IP based access policy [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Elasticsearch domain $domain does not have and IP based access policy [$insecure Warnings]"
    fi
  done
}

