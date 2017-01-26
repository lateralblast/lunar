# audit_aws_es
#
# Identify any publicly accessible AWS Elasticsearch domains and update their
# access policy in order to stop any unsigned requests made to these resources
# (ES clusters).
#
# Allowing anonymous access to your ES domains is not recommended and is
# considered bad practice. To protect your domains against unauthorized access,
# Amazon ElasticSearch Service provides preconfigured access policies (resource-
# -based, IP-based and IAM user/role-based policies) that you can customize as
# needed, as well as the ability to import access policies from other AWS ES
# domains.
#
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/elasticsearch-domain-exposed.html
#.

audit_aws_es () {
  domains=`aws es list-domain-names --region $aws_region --query "DomainNames[].DomainName" --output text`
  for domain in $domains; do
    total=`expr $total + 1`
    check=`aws es describe-elasticsearch-domain --domain-name $domain --query 'DomainStatus.AccessPolicies' --output text |grep "{\"AWS\":\"\*\"}"`
    if [ ! "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Elasticsearch doamin $domain is not publicly accessible [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Elasticsearch domain $domain is publicly accessible [$insecure Warnings]"
    fi
  done
}

