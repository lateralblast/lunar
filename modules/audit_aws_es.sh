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
#
# Ensure that the access to your Elasticsearch Service (ES) domains is made
# based on whitelisted IP addresses only in order to protect them against
# unauthorized access. Prior to running this rule by the Cloud Conformity
# engine, you need to specify the IP addresses that you want to whitelist in
# the rule settings available on the Cloud Conformity console. The IPs must
# be valid IPv4 addresses (e.g. 54.197.25.93/32), IP address ranges
# (e.g. 52.71.100.5/24) or CIDR blocks (e.g. 172.31.0.0/16).
#
# Using ES IP-based access policies will allow only specific IP addresses or IP
# address ranges to access your Elasticsearch domains endpoints, acting as a
# firewall that prevents incoming anonymous or unauthorized requests from
# reaching your ES clusters. 
# 
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

