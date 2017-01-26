# audit_aws_rec_es
#
# Ensure that your AWS Elasticsearch Service (ES) clusters are using
# dedicated master nodes to improve their environmental stability by
# offloading all the management tasks from the cluster data nodes.
#
# Using Elasticsearch dedicated master nodes to separate management tasks from
# index and search requests will improve the clusters ability to manage easily
# different types of workload and make them more resilient in production.
#
# Refer to https://www.cloudconformity.com/conformity-rules/Elasticsearch/elasticsearch-dedicated-master-enabled.html
#.

audit_aws_rec_es () {
  domains=`aws es list-domain-names --region $aws_region --query "DomainNames[].DomainName" --output text`
  for domain in $domains; do
    total=`expr $total + 1`
    check=`aws es describe-elasticsearch-domain --domain-name $domain --query "DomainStatus.ElasticsearchClusterConfig.DedicatedMasterEnabled" |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Elasticsearch doamin $domain has dedicated master nodes [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Elasticsearch domain $domain does not have dedicated master nodes [$insecure Warnings]"
    fi
  done
}

